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

describe Kanagata::Base do
  context '#initialize' do
    context 'success' do
      it 'initialize w/ all parameters' do
        Dir.mktmpdir do |tmpdir|
          yaml = ~<<-"EOF"
            target:
              attributes:
              templates_dir: ./kanagata
              templates:
                - path: ./template_file
          EOF
          config_file = File.join(tmpdir, 'config_file')
          File.write(config_file, yaml)
          base = Kanagata::Base.new('target', config_file, [])
        end
      end

      it 'initialize w/o templates_dir' do
        Dir.mktmpdir do |tmpdir|
          yaml = ~<<-"EOF"
            target:
              attributes:
              templates:
                - path: ./hoge.json
          EOF
          config_file = File.join(tmpdir, 'config_file')
          File.write(config_file, yaml)
          base = Kanagata::Base.new('target', config_file, [])
        end
      end

      it 'initialize w/o attributes' do
        Dir.mktmpdir do |tmpdir|
          yaml = ~<<-"EOF"
            target:
              templates_dir: ./kanagata
              templates:
                - path: ./hoge.json
          EOF
          config_file = File.join(tmpdir, 'config_file')
          File.write(config_file, yaml)
          base = Kanagata::Base.new('target', config_file, [])
          expect(base).to_not eq nil
        end
      end
    end

    context 'failure' do
      it 'initialize w/o templates' do
        Dir.mktmpdir do |tmpdir|
          yaml = ~<<-"EOF"
            target:
              attributes:
              templates_dir: ./kanagata
          EOF
          config_file = File.join(tmpdir, 'config_file')
          File.write(config_file, yaml)
          expect {
            Kanagata::Base.new('target', config_file, [])
          }.to raise_error RuntimeError
        end
      end

      it 'initialize w/o top level key' do
        Dir.mktmpdir do |tmpdir|
          yaml = ~<<-"EOF"
            hoge::
              attributes:
              templates_dir: ./kanagata
              templates:
                - path: ./template_file
          EOF
          config_file = File.join(tmpdir, 'config_file')
          File.write(config_file, yaml)
          expect {
            Kanagata::Base.new('target', config_file, [])
          }.to raise_error RuntimeError
        end
      end
    end
  end
end
