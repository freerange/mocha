require File.expand_path('../../test_helper', __FILE__)

require "test/unit"
require "mocha"
require "adapters/shared_adapter_tests"

class TestUnitTest < Test::Unit::TestCase
  include SharedAdapterTests
end
