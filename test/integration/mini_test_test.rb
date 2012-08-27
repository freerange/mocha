require File.expand_path('../../test_helper', __FILE__)

require "minitest/unit"
require "mocha"
require "integration/shared_tests"

class MiniTestTest < Test::Unit::TestCase
  include SharedTests
end
