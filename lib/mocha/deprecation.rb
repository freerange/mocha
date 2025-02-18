# frozen_string_literal: true

require 'mocha/backtrace_filter'

module Mocha
  class Deprecation
    class Logger
      def warning(message)
        filter = BacktraceFilter.new
        location = filter.filtered(caller)[0]
        warn "Mocha deprecation warning at #{location}: #{message}"
      end
    end

    class << self
      attr_writer :logger

      def warning(message)
        logger.call(message)
      end

      def logger
        @logger ||= Logger.new
      end
    end
  end
end
