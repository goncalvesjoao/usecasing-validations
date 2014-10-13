# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'usecasing_validations/version'

Gem::Specification.new do |gem|
  gem.name          = "usecasing_validations"
  gem.version       = UseCaseValidations::VERSION
  gem.authors       = ["João Gonçalves"]
  gem.email         = ["goncalves.joao@gmail.com"]
  gem.description   = "UseCase Gem Extention to add Rails like validations"
  gem.summary       = "UseCase Gem Extention to add Rails like validations without Rails, only needs Ruby and usecasing gem"
  gem.homepage      = "https://github.com/goncalvesjoao/usecasing-validations"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'usecasing', "~> 0.1"
end
