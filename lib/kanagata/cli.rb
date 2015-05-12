require 'thor'

module Kanagata
  class CLI < Thor
    desc 'init', 'generate kanagata skelton files'
    def init(target = 'target')
      begin
        skelton = Kanagata::Skelton.new(target)
        skelton.generate
      rescue => e
        say(e.message, :red)
      end
    end

    option :config, default: '.kanagata'
    desc 'generate target', 'generate files'
    def generate(target, *attributes)
      begin
        generator = Kanagata::Generator.new(target, options[:config], attributes)
        generator.generate
      rescue => e
        say(e.message, :red)
      end
    end

    option :config, default: '.kanagata'
    desc 'destroy target', 'destroy files'
    def destroy(target, *attributes)
      begin
        destroyer = Kanagata::Destroyer.new(target, options[:config], attributes)
        destroyer.destroy
      rescue => e
        say(e.message, :red)
      end
    end
  end
end
