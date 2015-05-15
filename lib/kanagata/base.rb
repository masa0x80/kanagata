require 'yaml'
require 'erubis'
require 'pathname'
require 'fileutils'

module Kanagata
  class Base
    def initialize(target, config_file, attributes = [])
      config = load_and_validate(target, config_file)
      @pwd           = File.expand_path('.')
      @templates     = config['templates']
      @attributes    = config['attributes'] || {}
      @templates_dir = config.key?('templates_dir') ? File.expand_path(config['templates_dir']) : File.join(@pwd, 'kanagata')
      attributes.each do |value|
        k, v = value.split(':')
        @attributes[k] = v
      end
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

    def relative_path_of(file)
      Pathname.new(file).relative_path_from(Pathname.new(@pwd))
    end

    def info(text)
      puts "\t#{text}"
    end
  end
end
