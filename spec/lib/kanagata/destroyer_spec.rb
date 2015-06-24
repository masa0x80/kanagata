require 'spec_helper'
require 'fileutils'
require 'tmpdir'

module PatchedString
  refine String do
    def ~
      mergin = scan(/^ +/).map(&:size).min
      gsub(/^ {#{mergin}}/, '')
    end
  end
end
using PatchedString

describe Kanagata::Destroyer do
  before do
    @tmpdir = Dir.mktmpdir('tmpdir', File.expand_path('.'))
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
    @destroyer = Kanagata::Destroyer.new('target', config_file)
  end

  after do
    FileUtils.remove_entry_secure @tmpdir
  end

  context '#remove_dirs' do
    it 'rm -rf' do
      target_file = File.join(@tmpdir, 'path', 'to', 'file')
      FileUtils.mkdir_p(File.dirname(target_file))
      FileUtils.touch(target_file)
      expected = ~<<-"EOF"
        \t#{File.basename(@tmpdir)}\/path\/to is not empty
        \t#{File.basename(@tmpdir)}\/path is not empty
        \t#{File.basename(@tmpdir)} is not empty
      EOF
      expect {
        @destroyer.remove_dirs(target_file)
      }.to output(expected).to_stdout

      FileUtils.rm(target_file)
      expected = ~<<-"EOF"
        \tremove dir #{File.basename(@tmpdir)}\/path\/to
        \tremove dir #{File.basename(@tmpdir)}\/path
        \t#{File.basename(@tmpdir)} is not empty
      EOF
      expect {
        @destroyer.remove_dirs(target_file)
      }.to output(expected).to_stdout

      expected = ~<<-"EOF"
        \tAlready removed: #{File.basename(@tmpdir)}\/path\/to
        \tAlready removed: #{File.basename(@tmpdir)}\/path
        \t#{File.basename(@tmpdir)} is not empty
      EOF
      expect {
        @destroyer.remove_dirs(target_file)
      }.to output(expected).to_stdout
    end
  end

  context '#destroy' do
    it 'destroy expected files' do
      filepath1 = File.join(@tmpdir, 'hoge.yml')
      filepath2 = File.join(@tmpdir, 'filename.yml')
      FileUtils.touch(filepath1)
      FileUtils.touch(filepath2)
      expect(File.exist?(filepath1)).to eq true
      expect(File.exist?(filepath2)).to eq true
      expected = ~<<-"EOF"
        \tremove     #{File.basename(@tmpdir)}/#{File.basename(filepath1)}
        \t#{File.basename(@tmpdir)} is not empty
        \tremove     #{File.basename(@tmpdir)}/#{File.basename(filepath2)}
        \t#{File.basename(@tmpdir)} is not empty
      EOF
      expect {
        @destroyer.destroy
      }.to output(expected).to_stdout
      expect(File.exist?(filepath1)).to eq false
      expect(File.exist?(filepath2)).to eq false

      expected = ~<<-"EOF"
        \tAlready removed: #{File.basename(@tmpdir)}/#{File.basename(filepath1)}
        \t#{File.basename(@tmpdir)} is not empty
        \tAlready removed: #{File.basename(@tmpdir)}/#{File.basename(filepath2)}
        \t#{File.basename(@tmpdir)} is not empty
      EOF
      expect {
        @destroyer.destroy
      }.to output(expected).to_stdout
    end
  end
end
