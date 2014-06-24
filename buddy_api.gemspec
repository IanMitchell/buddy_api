# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buddy_api/version'

Gem::Specification.new do |spec|
  spec.name          = "buddy_api"
  spec.version       = BuddyAPI::VERSION
  spec.authors       = ["Ian Mitchell"]
  spec.email         = ["ian.mitchel1@live.com"]
  spec.summary       = %q{A gem that interacts with Buddy Platform's REST API service.}
  spec.description   = %q{This is a 3rd party gem that interfaces with Buddy Platform's API.}
  spec.homepage      = "http://github.com/ianmitchell/buddy_api"
  spec.license       = "MIT"

  #spec.files         = `git ls-files -z`.split("\x0")
  spec.files         = Dir["{lib,test}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
