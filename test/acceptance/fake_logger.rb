# frozen_string_literal: true

require 'mocha/logger'

class FakeLogger
  def initialize
    @warnings_by_category = Hash.new { |h, k| h[k] = [] }
  end

  def warning(message, category: nil)
    @warnings_by_category[category] << message
  end

  def warnings(category: nil)
    @warnings_by_category[category]
  end

  def deprecation_warnings
    @warnings_by_category[:deprecation]
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
