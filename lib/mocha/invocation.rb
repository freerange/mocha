require 'mocha/raised_exception'

module Mocha
  class Invocation
    # @private
    def initialize(yield_parameters, return_values)
      @yield_parameters = yield_parameters
      @return_values = return_values
    end

    # @private
    def call
      @yield_parameters.next_invocation.each do |yield_parameters|
        yield(*yield_parameters)
      end
      begin
        @result = @return_values.next
        # rubocop:disable Lint/RescueException
      rescue Exception => e
        # rubocop:enable Lint/RescueException
        @result = RaisedException.new(e)
        raise
      end
    end

    # @private
    def mocha_inspect
      @result.mocha_inspect
    end
  end
end
