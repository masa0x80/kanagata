require 'yaml'
require 'erubis'
require 'fileutils'

module Kanagata
  class Destroyer < Kanagata::Base
    def destroy
      @templates.each do |template|
        output_filename = Erubis::Eruby.new(template['name'] || File.basename(template['path'])).result(@attributes)
        output_file     = File.expand_path(File.join(File.dirname(template['path']), output_filename))
        begin
          if File.exist?(output_file)
            FileUtils.rm(output_file)
            puts "delete #{output_file}"
          end
        rescue => e
          raise "Error: delete #{output_file}"
        end
      end
    end
  end
end
