Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = 'filters_spam'
  s.version       = '0.1'
  s.summary       = 'Attach to your model to have this filter out the spam using scoring techniques.'
  s.description   = 'This is a small Ruby on Rails plugin that can be installed as a gem in your Gemfile that allows models to attach to it to provide spam filtering functionality.'
  s.authors       = ["Philip Arndt", "David Jones"]
  s.homepage      = 'http://www.resolvedigital.co.nz'
  s.email         = 'info@resolvedigital.co.nz'

  s.files         = ['readme.md', 'lib/filters_spam.rb']
  s.require_path  = 'lib'
  s.requirements  << 'none'

  s.required_ruby_version = '>= 1.8.7'
end
