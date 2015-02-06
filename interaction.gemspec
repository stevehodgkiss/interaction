# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interaction/version'

Gem::Specification.new do |spec|
  spec.name          = "interaction"
  spec.version       = Interaction::VERSION
  spec.authors       = ["Steve Hodgkiss"]
  spec.email         = ["steve@hodgkiss.me"]
  spec.summary       = %q{Provides a convention for modelling user interactions as use case classes.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/stevehodgkiss/interaction"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activemodel"
  spec.add_dependency "virtus", ">= 1.0.4"
end
