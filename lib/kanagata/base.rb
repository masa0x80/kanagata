require 'yaml'
require 'erubis'
require 'fileutils'

module Kanagata
  class Base
    def initialize(target, config_file)
      config = load_and_validate(target, config_file)
      @templates     = config['templates']
      @attributes    = config['attributes'] || {}
      @templates_dir = config['templates_dir'].nil? ? File.join(File.dirname(expand_path), 'kanagata') : File.expand_path(config['templates_dir'])
    end

    private
    def load_and_validate(target, config_file)
      yaml = YAML.load_file(File.expand_path(config_file))
      validate(yaml, target)
      config = yaml[target]
      validate(config, 'templates')
      config['templates'].each do |file|
        validate(file, 'path')
      end
      config
    end

    def validate(hash, key)
      raise "Error: config file format is invalid -- '#{key}' is not found." unless hash.key?(key)
    end
  end
end
