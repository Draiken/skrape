# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skrape/version'

Gem::Specification.new do |gem|
  gem.name          = "skrape"
  gem.version       = Skrape::VERSION
  gem.authors       = ["Luiz Felipe Garcia Pereira"]
  gem.email         = ["luiz.felipe.gp@gmail.com"]
  gem.description   = "Very simple skraping api for ruby"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]
end
