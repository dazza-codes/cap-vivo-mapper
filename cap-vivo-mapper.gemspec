# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cap/vivo/version'

Gem::Specification.new do |spec|
  spec.name          = "cap-vivo-mapper"
  spec.version       = Cap::Vivo::VERSION
  spec.authors       = ["Darren L. Weber, Ph.D."]
  spec.email         = ["darren.weber@stanford.edu"]

  spec.summary       = %q{This utility maps Stanford CAP profiles to VIVO.}
  spec.description   = %q{This utility maps Stanford CAP profiles to VIVO.}
  spec.homepage      = 'https://github.com/sul-dlss/cap-vivo-mapper'
  spec.licenses      = ['Apache-2.0']

  spec.add_dependency 'dotenv'

  spec.add_dependency 'daybreak' # memory mapped file db
  spec.add_dependency 'mongo'

  spec.add_dependency 'linkeddata'
  spec.add_dependency 'rdf-4store'

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

  # Use pry for console and debug config
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-ctags-bundler'

  git_files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  bin_files = %w(bin/console bin/ctags.rb bin/setup bin/test.rb)
  dot_files = %w(.gitignore .travis.yml log/.gitignore)

  spec.files         = git_files - (bin_files + dot_files)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

end
