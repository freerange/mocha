source 'https://rubygems.org'

gemspec

# rubocop:disable Bundler/DuplicatedGem
if RUBY_VERSION < '1.9.3'
  gem 'rake', '~> 10.0'
elsif RUBY_VERSION < '2'
  gem 'rake', '~> 12.2.1'
elsif RUBY_VERSION < '2.2'
  gem 'rake', '~> 12.3.3'
else
  gem 'rake'
end
# rubocop:enable Bundler/DuplicatedGem

gem 'introspection', '~> 0.0.1'

# Avoid breaking change in psych v4 (https://bugs.ruby-lang.org/issues/17866)
if RUBY_VERSION >= '3.1.0'
  gem 'psych', '< 4'
end

if RUBY_VERSION >= '2.2.0'
  # No test libraries in standard library
  gem 'minitest'
end
if RUBY_VERSION >= '2.2.0'
  gem 'rubocop', '<= 0.58.2'
end
if ENV['MOCHA_GENERATE_DOCS']
  gem 'redcarpet'
  gem 'yard'
end
