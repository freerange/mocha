require File.expand_path('../../test_helper', __FILE__)

require 'mocha/integration/test_unit'

class Test::Unit::TestCase
  include Mocha::Integration::TestUnit
end

require "integration/shared_integration_tests"

class TestUnitTest < Test::Unit::TestCase
  include SharedIntegrationTests
end
