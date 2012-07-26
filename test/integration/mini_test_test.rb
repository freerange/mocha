require File.expand_path('../../test_helper', __FILE__)

require 'mocha/integration/mini_test'

class MiniTest::Unit::TestCase
  include Mocha::Integration::MiniTest
end

require "integration/shared_integration_tests"

class MiniTestTest < Test::Unit::TestCase
  include SharedIntegrationTests
end
