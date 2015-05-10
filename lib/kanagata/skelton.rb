require 'fileutils'

module Kanagata
  class Skelton
    def initialize(target)
      @target        = target
      @config_file   = File.expand_path('.kanagata')
      @template_file = File.expand_path('./kanagata/file.yml.erb')
    end

    def generate
      FileUtils.mkdir_p('kanagata')
      unless File.exist?(@config_file)
        File.open(@config_file, 'w') do |file|
          file.puts "#{@target}:"
          file.puts '  attributes:'
          file.puts '    key: value'
          file.puts '  templates_dir: ./kanagata'
          file.puts '  templates:'
          file.puts '    - path: ./path/to/file.yml'
          file.puts '      name: <%= key %>.yml'
        end
      end
      unless File.exist?(@template_file)
        File.open(@template_file, 'w') do |file|
          file.puts 'sample:'
          file.puts '  - <%= key %>'
        end
      end
    end
  end
end
