# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'test_runner'
require 'mocha/configuration'
require 'mocha/mockery'
require 'mocha/logger'
require 'introspection'

if Mocha::Detection::Minitest.testcase && (ENV['MOCHA_RUN_INTEGRATION_TESTS'] != 'test-unit')
  require 'mocha/minitest'
else
  require 'mocha/test_unit'
end

module AcceptanceTestHelper
  class FakeLogger
    attr_reader :warnings

    def initialize
      @warnings = []
    end

    def warning(message)
      @warnings << message
    end
  end

  attr_reader :logger

  include TestRunner

  def setup_acceptance_test
    Mocha::Configuration.reset_configuration
    @logger = FakeLogger.new
    Mocha::Logger.logger = @logger
  end

  def teardown_acceptance_test
    Mocha::Configuration.reset_configuration
  end

  include Introspection::Assertions
end
