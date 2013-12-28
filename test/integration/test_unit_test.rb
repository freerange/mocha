require File.expand_path('../../test_helper', __FILE__)

require "mocha/integration/test_unit"
require "integration/shared_tests"

Mocha::Integration::TestUnit.activate

class TestUnitTest < Mocha::TestCase
  include SharedTests
end
