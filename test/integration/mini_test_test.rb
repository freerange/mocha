require File.expand_path('../../test_helper', __FILE__)

require "mocha/integration/mini_test"
require "integration/shared_tests"

Mocha::Integration::MiniTest.activate

class MiniTestTest < Mocha::TestCase
  include SharedTests
end
