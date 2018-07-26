require 'mocha/backtrace_filter'

module Mocha
  class Deprecation
    class << self
      attr_accessor :mode, :messages

      def warning(message)
        @messages << message
        return if mode == :disabled
        filter = BacktraceFilter.new
        location = filter.filtered(caller)[0]
        warn "Mocha deprecation warning at #{location}: #{message}"
      end
    end

    self.mode = :enabled
    self.messages = []
  end
end
