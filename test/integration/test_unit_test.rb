require File.expand_path('../../test_helper', __FILE__)

require "test/unit"
require "mocha/integration/test_unit"
require "integration/shared_tests"

Mocha::Integration::TestUnit.activate

class TestUnitTest < Test::Unit::TestCase
  include SharedTests
end
