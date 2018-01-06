require 'mocha/backtrace_filter'

module Mocha

  class Deprecation

    class << self

      attr_accessor :mode, :messages

      def warning(message)
        @messages << message
        unless mode == :disabled
          filter = BacktraceFilter.new
          location = filter.filtered(caller)[0]
          $stderr.puts "Mocha deprecation warning at #{location}: #{message}"
        end
      end

    end

    self.mode = :enabled
    self.messages = []

  end

end
