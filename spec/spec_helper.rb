$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kanagata'
require 'tmpdir'

module PatchedString
  refine String do
    def ~
      mergin = scan(/^ +/).map(&:size).min
      gsub(/^ {#{mergin}}/, '')
    end
  end
end

module KanagataTest
  class << self
    def silence
      Dir.mktmpdir do |tmpdir|
        $stdout = File.open(File.join(tmpdir, 'stdout'), 'w')
        yield
        $stdout = STDOUT
      end
    end
  end
end
