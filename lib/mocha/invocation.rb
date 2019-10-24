require 'mocha/raised_exception'

module Mocha
  class Invocation
    # @private
    def initialize(return_values)
      @return_values = return_values
    end

    # @private
    def call
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
