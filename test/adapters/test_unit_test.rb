require File.expand_path('../../test_helper', __FILE__)

require 'mocha/test_unit'
require "adapters/shared_adapter_tests"

class TestUnitTest < Test::Unit::TestCase
  include SharedAdapterTests
end
