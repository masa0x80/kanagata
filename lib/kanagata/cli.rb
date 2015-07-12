require 'thor'

module Kanagata
  class CLI < Thor
    desc 'init', 'Generate sample recipe and template files'
    def init(target = 'sample')
      begin
        skelton = Kanagata::Skelton.new(target)
      rescue => e
        say(e.message, :red)
      end
    end

    option :config, default: '.kanagata'
    desc 'generate [RECIPE_NAME]', 'Generate files based on recipe and template files'
    def generate(target, *attributes)
      begin
        generator = Kanagata::Generator.new(target, options[:config], attributes)
        generator.generate
      rescue => e
        say(e.message, :red)
      end
    end

    option :config, default: '.kanagata'
    desc 'destroy [RECIPE_NAME]', 'Destroy files based on recipe and template files'
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
