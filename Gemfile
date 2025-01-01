source 'https://rubygems.org'

gemspec

group :development do
  gem 'introspection', '~> 0.0.1'
  gem 'minitest'
  gem 'rake'

  if RUBY_ENGINE == 'jruby'
    # Workaround for https://github.com/jruby/jruby/issues/8488
    gem 'jar-dependencies', '~> 0.4.1'
  end

  if ENV['MOCHA_GENERATE_DOCS']
    gem 'redcarpet'
    gem 'yard'
  end
end
