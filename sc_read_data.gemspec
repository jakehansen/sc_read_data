# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sc_read_data/version'

Gem::Specification.new do |spec|
  spec.name          = "sc_read_data"
  spec.version       = ScReadData::VERSION
  spec.authors       = ["Jake Hansen"]
  spec.email         = ["utahtio@yahoo.com"]
  spec.summary       = %q{A simple app for reading csv data.}
  spec.description   = %q{ScReadData is a command line application for parsing business and user csv data into a readable format.}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('rake', '~> 0.9.2')
  spec.add_dependency('methadone', '~> 1.3.2')
  spec.add_dependency('sqlite3')
  spec.add_dependency('activesupport')
end
