require File.expand_path('../../test_helper', __FILE__)

require 'mocha/adapters/mini_test'

class MiniTest::Unit::TestCase
  include Mocha::Adapters::MiniTest
end

require "adapters/shared_adapter_tests"

class MiniTestTest < Test::Unit::TestCase
  include SharedAdapterTests
end
