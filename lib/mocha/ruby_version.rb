module Mocha
  PRE_RUBY_V19 = Gem::Version.new(RUBY_VERSION) < Gem::Version.new('1.9')
end
