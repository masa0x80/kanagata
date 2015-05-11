require 'fileutils'

module Kanagata
  class Skelton
    def initialize(target)
      @target        = target
      @config_file   = File.expand_path('.kanagata')
      @templates_dir = File.expand_path('./kanagata')
      @template_file = File.expand_path('./kanagata/file.yml.erb')
    end

    def generate
      begin
        if File.exist?(@config_file)
          puts "#{@config_file} already exists"
        else
          File.open(@config_file, 'w') do |file|
            file.puts "#{@target}:"
            file.puts '  attributes:'
            file.puts '    key: value'
            file.puts '  templates_dir: ./kanagata'
            file.puts '  templates:'
            file.puts '    - path: ./path/to/file.yml'
            file.puts '      name: <%= key %>.yml'
          end
          puts "generate #{@config_file}"
        end

        puts "mkdir -p #{FileUtils.mkdir_p(@templates_dir).first}" unless File.exist?(@templates_dir)
        if File.exist?(@template_file)
          puts "#{@template_file} already exists"
        else
          File.open(@template_file, 'w') do |file|
            file.puts 'sample:'
            file.puts '  - <%= key %>'
          end
          puts "generate #{@template_file}"
        end
      rescue => e
        raise e.message
      end
    end
  end
end
