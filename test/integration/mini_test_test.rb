require File.expand_path('../../test_helper', __FILE__)

require "minitest/unit"
require "mocha/setup"
require "integration/shared_tests"

class MiniTestTest < Mocha::TestCase
  include SharedTests
end
