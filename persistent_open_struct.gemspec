# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'persistent_open_struct/version'

Gem::Specification.new do |spec|
  spec.name          = "persistent_open_struct"
  spec.version       = PersistentOpenStruct::VERSION
  spec.authors       = ["amcaplan"]
  spec.email         = ["ariel.caplan@vitals.com"]
  spec.summary       = %q{A variant of OpenStruct that persists defined methods}
  spec.description   = %q{Unlike OpenStruct, which defines singleton methods on an object, PersistentOpenStruct defines methods on the class.  This is useful when storing many hashes with the same keys as OpenStructs.}
  spec.homepage      = "http://github.com/amcaplan/persistent_open_struct"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.4.3"
end
