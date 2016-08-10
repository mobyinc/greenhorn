# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'greenhorn/version'

Gem::Specification.new do |spec|
  spec.name          = 'greenhorn'
  spec.version       = Greenhorn::VERSION
  spec.authors       = ['Josh Leitzel']
  spec.email         = ['joshleitzel@gmail.com']

  spec.summary       = 'CraftCMS + ActiveRecord'
  spec.description   = 'Provides an ActiveRecord interface to a Craft CMS database'
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 4.2'
  spec.add_dependency 'dimensions', '~> 1.3'
  spec.add_dependency 'fastimage', '~> 2.0'
  spec.add_dependency 'fog-aws', '~> 0.9'
  spec.add_dependency 'fog-local', '~> 0.3'
  spec.add_dependency 'httparty', '~> 0.13'
  spec.add_dependency 'mime-types', '~> 3.1'
  spec.add_dependency 'mysql2', '~> 0.4'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'database_cleaner', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.41'
  spec.add_development_dependency 'yard', '~> 0.9'
end
