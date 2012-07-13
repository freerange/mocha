require 'mocha/backtrace_filter'
require 'mocha/expectation_error'

module Mocha
  class ExpectationErrorFactory
    class << self
      attr_accessor :exception_class
      def build(message = nil, backtrace = [])
        self.exception_class ||= ExpectationError
        exception = exception_class.new(message)
        filter = BacktraceFilter.new
        exception.set_backtrace(filter.filtered(backtrace))
        exception
      end
    end
  end
end
