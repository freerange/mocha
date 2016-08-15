module Mocha
  PRE_RUBY_V19 = Gem::Version.new(RUBY_VERSION) < Gem::Version.new('1.9')
  RUBY_V2_PLUS = Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2')
end
