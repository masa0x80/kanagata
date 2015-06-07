require 'yaml'
require 'erubis'
require 'pathname'
require 'fileutils'

module Kanagata
  class Base
    def initialize(target, config_file, attributes = [])
      config = load_and_validate(target, config_file)
      @templates     = config['templates']
      @attributes    = merge_attributes(config['attributes'] || {}, attributes)
      @templates_dir = config.key?('templates_dir') ? File.expand_path(config['templates_dir']) : File.join(File.expand_path('.'), 'kanagata')
    end

    private
    include Kanagata::Util
  end
end
