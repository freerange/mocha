# frozen_string_literal: true

require 'mocha/backtrace_filter'
require 'mocha/logger'

module Mocha
  class Deprecation
    class << self
      def warning(message)
        filter = BacktraceFilter.new
        location = filter.filtered(caller)[0]
        Logger.warning("Mocha deprecation warning at #{location}: #{message}", category: :deprecation)
      end
    end
  end
end
