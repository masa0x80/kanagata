require 'spec_helper'
require 'fileutils'
require 'tmpdir'

include PatchedString
using PatchedString

describe Kanagata::Generator do
  before do
    @tmpdir = Dir.mktmpdir
    Dir.mkdir(File.join(@tmpdir, 'kanagata'))
    yaml = ~<<-"EOF"
      target:
        attributes:
          key1: value1
          key2: value2
          filename: filename
        templates_dir: #{@tmpdir}/kanagata
        templates:
          - path: #{@tmpdir}/hoge.yml
          - path: #{@tmpdir}/fuga.yml
            name: <%= filename %>.yml
    EOF
    config_file = File.join(@tmpdir, 'config_file')
    File.write(config_file, yaml)
    @generator = Kanagata::Generator.new('target', config_file)
  end

  after do
    FileUtils.remove_entry_secure @tmpdir
  end

  context '#make_dirs' do
    it 'mkdir -p' do
      target_dir = File.join(@tmpdir, 'hoge', 'fuga')
      expect {
        @generator.make_dirs(target_dir)
      }.to output(/create dir \S+\/hoge/).to_stdout

      expect {
        @generator.make_dirs(target_dir)
      }.to output(/Already exists: \S+\/hoge/).to_stdout
    end
  end

  context '#generate' do
    it 'generate expected files' do
      template_body1 = ~<<-"EOF"
        template1:
          key: <%= key1 %>
      EOF
      template_body2 = ~<<-"EOF"
        template2:
          key: <%= key2 %>
      EOF
      File.write(File.join(@tmpdir, 'kanagata', 'hoge.yml.erb'), template_body1)
      File.write(File.join(@tmpdir, 'kanagata', 'fuga.yml.erb'), template_body2)
      KanagataTest.silence do
        @generator.generate
      end
      actual   = File.read(File.join(@tmpdir, 'hoge.yml'))
      expected = ~<<-"EOF"
        template1:
          key: value1
      EOF
      expect(actual).to eq expected

      actual   = File.read(File.join(@tmpdir, 'filename.yml'))
      expected = ~<<-"EOF"
        template2:
          key: value2
      EOF
      expect(actual).to eq expected
    end

    it 'already exists file' do
      template_body = ~<<-"EOF"
        template1:
          key: value
      EOF
      File.write(File.join(@tmpdir, 'kanagata', 'hoge.yml.erb'), template_body)
      FileUtils.touch(File.join(@tmpdir, 'hoge.yml'))
      KanagataTest.silence do
        expect {
          @generator.generate
        }.to raise_error
      end
      expect(File.exist?(File.join(@tmpdir, 'hoge.yml'))).to eq true
    end

    it 'failed to generate file' do
      template_body = ~<<-"EOF"
        template1:
          key: <%= unknown_key %>
      EOF
      File.write(File.join(@tmpdir, 'kanagata', 'hoge.yml.erb'), template_body)
      KanagataTest.silence do
        expect {
          @generator.generate
        }.to raise_error
      end
      expect(File.exist?(File.join(@tmpdir, 'hoge.yml'))).to eq false
    end
  end
end
