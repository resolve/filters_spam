# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "filter_spam"
  s.summary = "Insert FilterSpam summary."
  s.description = "Insert FilterSpam description."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 2.6.rc"
end
