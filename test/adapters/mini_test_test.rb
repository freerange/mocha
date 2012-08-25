require File.expand_path('../../test_helper', __FILE__)

require "minitest/unit"
require "mocha"
require "adapters/shared_adapter_tests"

class MiniTestTest < Test::Unit::TestCase
  include SharedAdapterTests
end
