require File.expand_path('../../test_helper', __FILE__)

require 'mocha/mini_test'
require "adapters/shared_adapter_tests"

class MiniTestTest < Test::Unit::TestCase
  include SharedAdapterTests
end
