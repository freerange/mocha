module Mocha
  RUBY_V2_PLUS = Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2')
  RUBY_V3_PLUS = Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('3')
end
