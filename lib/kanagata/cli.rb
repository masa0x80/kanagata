require 'thor'

module Kanagata
  class CLI < Thor
    desc 'init', 'generate kanagata skelton files'
    def init(target = 'target')
      skelton = Kanagata::Skelton.new(target)
      skelton.generate
    end

    option :config, default: '.kanagata'
    desc 'generate target', 'generate files'
    def generate(target)
      begin
        generator = Kanagata::Generator.new(target, options[:config])
        generator.generate
      rescue NoMethodError
        puts 'Error: config file format is invalid'
      end
    end
  end
end
