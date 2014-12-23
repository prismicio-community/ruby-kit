# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prismic/version'

Gem::Specification.new do |spec|
  spec.name          = 'prismic.io'
  spec.version       = Prismic::VERSION
  spec.authors       = ["Étienne Vallette d'Osia", 'Erwan Loisant', 'Samy Dindane', 'Rudy Rigot']
  spec.email         = ['evo@zenexity.com']
  spec.description   = %q{The standard Prismic.io's API library.}
  spec.summary       = %q{Prismic.io development kit}
  spec.homepage      = 'http://prismic.io'
  spec.license       = 'Apache-2'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'nokogiri', '~> 1.6'
  spec.add_development_dependency 'simplecov', '~> 0.7'
end
