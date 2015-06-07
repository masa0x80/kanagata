module Kanagata
  module Util
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

    def merge_attributes(config_attributes, args_attributes)
      args_attributes.each do |value|
        k, v = value.split(':')
        config_attributes[k] = v
      end
      config_attributes
    end

    def validate(hash, key)
      raise "Error: config file format is invalid -- '#{key}' is not found." unless hash.key?(key)
    end

    def relative_path_of(file)
      pwd = File.expand_path('.')
      Pathname.new(file).relative_path_from(Pathname.new(pwd))
    end

    def info(text)
      puts "\t#{text}"
    end
  end
end
