# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'test_runner'
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

  def setup_acceptance_test
    Mocha::Configuration.reset_configuration
  end

  def teardown_acceptance_test
    Mocha::Configuration.reset_configuration
  end

  def run_as_test_capturing_stderr(&block)
    test_result = nil
    _, stderr = capture_io do
      test_result = run_as_test(&block)
    end
    [test_result, stderr]
  end

  include Introspection::Assertions
end
