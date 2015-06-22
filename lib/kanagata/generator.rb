module Kanagata
  class Generator < Kanagata::Base
    def generate
      @templates.each do |template|
        output_filename = Erubis::Eruby.new(template['name'] || File.basename(template['path'])).result(@attributes)
        output_file     = File.expand_path(File.join(File.dirname(template['path']), output_filename))
        make_dirs(output_file)
        if File.exist?(output_file)
          info "Already exists: #{relative_path_of(output_file)}"
        else
          begin
            File.open(output_file, 'w') do |file|
              erubis = Erubis::Eruby.new(File.read(File.join(@templates_dir, "#{File.basename(template['path'])}.erb")))
              file.print erubis.result(@attributes)
              info "create     #{relative_path_of(output_file)}"
            end
          rescue => e
            FileUtils.rm(output_file)
            raise "Error: create #{relative_path_of(output_file)}"
          end
        end
      end
    end

    def make_dirs(file)
      relative_path_of(File.dirname(file)).descend do |dir|
        begin
          dir.mkdir
          info "create dir #{dir}"
        rescue Errno::EEXIST
          info "Already exists: #{dir}"
        rescue => e
          raise "Error: create dir #{dir}"
        end
      end
    end
  end
end
