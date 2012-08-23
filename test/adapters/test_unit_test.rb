require File.expand_path('../../test_helper', __FILE__)

require 'mocha/adapters/test_unit'

class Test::Unit::TestCase
  include Mocha::Adapters::TestUnit
end

require "adapters/shared_adapter_tests"

class TestUnitTest < Test::Unit::TestCase
  include SharedAdapterTests
end
