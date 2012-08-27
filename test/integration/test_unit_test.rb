require File.expand_path('../../test_helper', __FILE__)

require "test/unit"
require "mocha"
require "integration/shared_tests"

class TestUnitTest < Test::Unit::TestCase
  include SharedTests
end
