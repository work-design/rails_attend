$:.push File.expand_path('lib', __dir__)
require 'rails_attend/version'

Gem::Specification.new do |s|
  s.name = 'rails_attend'
  s.version = RailsAttend::VERSION
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_attend'
  s.summary = 'Summary of RailsAttend.'
  s.description = 'Description of RailsAttend.'
  s.license = 'LGPL-3.0'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails_com', '~> 1.2'
  s.add_development_dependency 'sqlite3'
end
