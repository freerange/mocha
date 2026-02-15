# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'test_runner'
require 'fake_logger'
require 'mocha/configuration'
require 'mocha/mockery'
require 'introspection'

if Mocha::Detection::Minitest.testcase && (ENV['MOCHA_RUN_INTEGRATION_TESTS'] != 'test-unit')
  require 'mocha/minitest'
else
  require 'mocha/test_unit'
end

module AcceptanceTestHelper
  include TestRunner
  include FakeLogger::TestHelper

  def setup_acceptance_test
    Mocha::Configuration.reset_configuration
    FakeLogger::TestHelper.setup
  end

  def teardown_acceptance_test
    Mocha::Configuration.reset_configuration
  end

  include Introspection::Assertions
end
