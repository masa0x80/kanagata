require 'yaml'
require 'erubis'
require 'fileutils'

module Kanagata
  class Generator
    def initialize(target, config_file)
      begin
        expand_path    = File.expand_path(config_file)
        config         = YAML.load_file(expand_path)[target]
        @templates     = config['templates']
        @attributes    = config['attributes']
        @templates_dir = config['templates_dir'].nil? ? File.join(File.dirname(expand_path), 'kanagata') : File.expand_path(config['templates_dir'])
      rescue => e
        raise e
      end
    end

    def generate
      @templates.each do |template|
        output_filename = Erubis::Eruby.new(template['name'] || File.basename(template['path'])).result(@attributes)
        output_file     = File.expand_path(File.join(File.dirname(template['path']), output_filename))
        FileUtils.mkdir_p(File.dirname(output_file))
        if File.exist?(output_file)
          puts "#{output_file} already exists"
        else
          File.open(output_file, 'w') do |file|
            erubis = Erubis::Eruby.new(File.read(File.join(@templates_dir, "#{File.basename(template['path'])}.erb")))
            file.print erubis.result(@attributes)
          end
        end
      end
    end
  end
end
