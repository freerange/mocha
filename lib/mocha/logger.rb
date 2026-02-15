# frozen_string_literal: true

module Mocha
  class Logger
    class << self
      attr_writer :logger

      def warning(*args)
        logger.warning(*args)
      end

      def logger
        @logger ||= new
      end
    end

    def warning(message)
      warn "WARNING: #{message}"
    end
  end
end
