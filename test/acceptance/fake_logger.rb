# frozen_string_literal: true

require 'mocha/logger'

class FakeLogger
  attr_reader :warnings

  def initialize
    @warnings = []
  end

  def warning(message)
    @warnings << message
  end

  module TestHelper
    def self.setup
      @original_logger = Mocha::Logger.logger
      Mocha::Logger.logger = FakeLogger.new
    end

    def self.teardown
      Mocha::Logger.logger = @original_logger
    end

    def logger
      Mocha::Logger.logger
    end
  end
end
