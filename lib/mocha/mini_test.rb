require 'mocha/adapters/mini_test'

class MiniTest::Unit::TestCase
  include Mocha::Adapters::MiniTest
end
