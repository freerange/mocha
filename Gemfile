source 'https://rubygems.org'

gemspec

gem 'introspection', '~> 0.0.1'
gem 'jaro_winkler', '>= 1.5.5'
gem 'minitest'
gem 'rake'
gem 'rubocop', '> 0.56', '<= 0.58.2'

# Avoid breaking change in psych v4 (https://bugs.ruby-lang.org/issues/17866)
if RUBY_VERSION >= '3.1.0'
  gem 'psych', '< 4'
end

# Avoid base64 gem warning about it not being available in Ruby v3.4
if RUBY_VERSION >= '3.3.0'
  gem 'base64'
end

# Avoid ostruct gem warning about it not being available in Ruby v3.5
if RUBY_VERSION >= '3.4.0'
  gem 'ostruct'
end

if RUBY_ENGINE == 'jruby'
  # Workaround for https://github.com/jruby/jruby/issues/8488
  gem 'jar-dependencies', '~> 0.4.1'
end

if ENV['MOCHA_GENERATE_DOCS']
  gem 'redcarpet'
  gem 'yard'
end
