# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rygsaek/version'

Gem::Specification.new do |spec|
  spec.name          = "rygsaek"
  spec.version       = Rygsaek::VERSION.dup
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Walther Diechmann", "Enrique Phillips"]
  spec.email         = "walther@diechmann.net"
  spec.summary       = "ActiveRecord based enclosures viewing, browsing, and persisting"
  spec.description   = "With the Rygsaek Gem your models may carry/share any binary enclosure - and get away with it!"
  spec.homepage      = "https://rygsaek.github.io"
  spec.licenses      = ["MIT"]

  spec.files         = `git ls-files -z`.split("\n")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = `git ls-files -- test/*`.split("\n")
  spec.require_paths = ["lib","lib/rygsaek"]

  # spec.add_dependency "rails"
  spec.add_dependency("orm_adapter", "~> 0.1")
  spec.add_dependency("bcrypt", "~> 3.0")
  spec.add_dependency("thread_safe", "~> 0.1")
  spec.add_dependency("railties", ">= 3.2.6", "< 5")
end

