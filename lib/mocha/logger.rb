# frozen_string_literal: true

require 'mocha/backtrace_filter'

module Mocha
  class Logger
    class << self
      attr_writer :logger

      def warning(*args, **kwargs)
        logger.warning(*args, **kwargs)
      end

      def logger
        @logger ||= new
      end
    end

    def warning(message, category: nil)
      filter = BacktraceFilter.new
      location = filter.filtered(caller)[0]
      prefix = ['Mocha', category, 'warning'].compact.join(' ')
      warn("#{prefix} at #{location}: #{message}")
    end
  end
end
