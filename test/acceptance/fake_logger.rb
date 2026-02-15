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
      Mocha::Logger.logger = FakeLogger.new
    end

    def logger
      Mocha::Logger.logger
    end
  end
end
