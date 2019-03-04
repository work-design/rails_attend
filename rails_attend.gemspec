$:.push File.expand_path('lib', __dir__)
require 'rails_attend/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = 'rails_attend'
  spec.version = RailsAttend::VERSION
  spec.authors = ['qinmingyuan']
  spec.email = ['mingyuan0715@foxmail.com']
  spec.homepage = 'TODO'
  spec.summary = 'TODO: Summary of RailsAttend.'
  spec.description = 'TODO: Description of RailsAttend.'
  spec.license = 'MIT'


  spec.files = Dir[
    '{app,config,db,lib}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  spec.add_dependency 'rails', '>= 5.2'

  spec.add_development_dependency 'sqlite3'
end
