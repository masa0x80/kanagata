module Kanagata
  class Destroyer < Kanagata::Base
    def destroy
      @templates.each do |template|
        output_filename = Erubis::Eruby.new(template['name'] || File.basename(template['path'])).result(@attributes)
        output_file     = File.expand_path(File.join(File.dirname(template['path']), output_filename))
        begin
          FileUtils.rm(output_file)
          info "remove     #{relative_path_of(output_file)}"
        rescue Errno::ENOENT
          info "Already removed: #{relative_path_of(output_file)}"
        rescue => e
          raise "Error: remove #{relative_path_of(output_file)}"
        ensure
          remove_dirs(output_file)
        end
      end
    end

    def remove_dirs(file)
      relative_path_of(File.dirname(file)).ascend do |dir|
        begin
          dir.rmdir
          info "remove dir #{dir}"
        rescue Errno::ENOENT
          info "Already removed: #{dir}"
        rescue Errno::ENOTEMPTY
          info "#{dir} is not empty"
        rescue => e
          raise "Error: remove dir #{dir}"
        end
      end
    end
  end
end
