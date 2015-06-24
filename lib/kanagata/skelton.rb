require 'fileutils'
require 'tmpdir'

module Kanagata
  class Skelton
    def initialize(target = 'target')
      Dir.mktmpdir do |tmpdir|
        yaml = <<-"EOF"
          skelton:
            attributes:
              target: '#{target}'
              meta_key: '<%= key %>'
            templates_dir: #{File.expand_path('../../../template_samples', __FILE__)}
            templates:
              - path: ./.kanagata
              - path: ./kanagata/sample.yml.erb
        EOF
        config_file = File.join(tmpdir, '.kanagata')
        File.write(config_file, yaml)
        generator = Kanagata::Generator.new('skelton', config_file)
        generator.generate
      end
    end
  end
end
