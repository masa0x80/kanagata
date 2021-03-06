# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kanagata/version'

Gem::Specification.new do |spec|
  spec.name          = "kanagata"
  spec.version       = Kanagata::VERSION
  spec.authors       = ["Kimura Masayuki"]
  spec.email         = ["masa0x80@gmail.com"]

  spec.summary       = 'Generate files based on recipe and template files.'
  spec.homepage      = "https://github.com/masa0x80/kanagata"
  spec.license       = "MIT"

  spec.files                 = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir                = "bin"
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths         = ["lib"]
  spec.required_ruby_version = ">= 2.2.0"

  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "erubis"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
end
