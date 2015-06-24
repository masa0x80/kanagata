require 'spec_helper'
require 'fileutils'
require 'tmpdir'

describe Kanagata::Skelton do
  describe '#initialize' do
    it 'w/ target' do
      Dir.mktmpdir do |tmpdir|
        FileUtils.cd(tmpdir) do
          expect {
            Kanagata::Skelton.new
          }.to_not raise_error
          conf_file_path = File.expand_path('.kanagata', tmpdir)
          expect(File.read(conf_file_path)).to match(/\Atarget:/)
          template_file_path = File.expand_path('kanagata/sample.yml.erb', tmpdir)
          expect(File.exist?(template_file_path)).to eq true
        end
      end
    end

    it 'w/o target' do
      Dir.mktmpdir do |tmpdir|
        FileUtils.cd(tmpdir) do
          expect {
            Kanagata::Skelton.new('foo')
          }.to_not raise_error
          conf_file_path = File.expand_path('.kanagata', tmpdir)
          expect(File.read(conf_file_path)).to match(/\Afoo:/)
          template_file_path = File.expand_path('kanagata/sample.yml.erb', tmpdir)
          expect(File.exist?(template_file_path)).to eq true
        end
      end
    end
  end
end
