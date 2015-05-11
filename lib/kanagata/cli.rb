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
      rescue => e
        say(e.message, :red)
      end
    end

    option :config, default: '.kanagata'
    desc 'destroy target', 'destroy files'
    def destroy(target)
      begin
        destroyer = Kanagata::Destroyer.new(target, options[:config])
        destroyer.destroy
      rescue => e
        say(e.message, :red)
      end
    end
  end
end
