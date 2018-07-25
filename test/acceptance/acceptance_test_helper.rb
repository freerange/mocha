require File.expand_path('../../test_helper', __FILE__)
require 'test_runner'
require 'mocha/configuration'
require 'introspection'

module AcceptanceTest
  class FakeLogger
    attr_reader :warnings

    def initialize
      @warnings = []
    end

    def warn(message)
      @warnings << message
    end
  end

  attr_reader :logger

  include TestRunner

  def setup_acceptance_test
    Mocha::Configuration.reset_configuration
    @logger = FakeLogger.new
    mockery = Mocha::Mockery.instance
    mockery.logger = @logger
  end

  def teardown_acceptance_test
    Mocha::Configuration.reset_configuration
  end

  include Introspection::Assertions
end
