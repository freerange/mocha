module Mocha
  RUBY_V23_PLUS = Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.3')
  RUBY_V27_PLUS = Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.7')
end
