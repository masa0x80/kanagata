require 'yaml'
require 'erubis'
require 'fileutils'

module Kanagata
  class Generator < Kanagata::Base
    def generate
      @templates.each do |template|
        output_filename = Erubis::Eruby.new(template['name'] || File.basename(template['path'])).result(@attributes)
        output_file     = File.expand_path(File.join(File.dirname(template['path']), output_filename))
        dirname = File.dirname(output_file)
        puts "mkdir -p #{FileUtils.mkdir_p(dirname).first}" unless File.exist?(dirname)
        if File.exist?(output_file)
          puts "#{output_file} already exists"
        else
          File.open(output_file, 'w') do |file|
            begin
              erubis = Erubis::Eruby.new(File.read(File.join(@templates_dir, "#{File.basename(template['path'])}.erb")))
              file.print erubis.result(@attributes)
              puts "generate #{output_file}"
            rescue => e
              FileUtils.rm(output_file)
              raise "Error: generate #{output_file}"
            end
          end
        end
      end
    end
  end
end
