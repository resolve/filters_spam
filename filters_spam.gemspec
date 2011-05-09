Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = 'filters_spam'
  s.version       = '1.0.0'
  s.summary       = 'Attach to your model to have this filter out the spam using scoring techniques.'
  s.description   = 'This is a small Ruby on Rails plugin that can be installed as a gem in your Gemfile that allows models to attach to it to provide spam filtering functionality.'
  s.authors       = ['Philip Arndt', 'David Jones', 'Uģis Ozols']
  s.homepage      = 'http://www.refinerycms.com'
  s.email         = 'phil@refinerycms.com'

  s.files         = Dir[File.expand_path('../**/*', __FILE__)]
  s.require_path  = 'lib'
  s.requirements  << 'none'

  s.required_ruby_version = '>= 1.8.7'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 2.6.rc'
end