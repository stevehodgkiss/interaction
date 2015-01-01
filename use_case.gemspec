# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'use_case/version'

Gem::Specification.new do |spec|
  spec.name          = "use_case"
  spec.version       = UseCase::VERSION
  spec.authors       = ["Steve Hodgkiss"]
  spec.email         = ["steve@hodgkiss.me"]
  spec.summary       = %q{Provides a convention for modelling user interactions as use case classes. Uses Virtus, ActiveModel Validations and Wisper.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_dependency "activesupport"
  spec.add_dependency "virtus"
  spec.add_dependency "activemodel"
  spec.add_dependency "wisper"
end
