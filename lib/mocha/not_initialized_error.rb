require 'mocha/backtrace_filter'

module Mocha

  # Exception raised when Mocha has not been initialized, e.g. outside the
  # context of a test.
  class NotInitializedError < StandardError

    # @private
    def initialize(message = nil, backtrace = [])
      super(message)
      filter = BacktraceFilter.new
      set_backtrace(filter.filtered(backtrace))
    end

  end

end
