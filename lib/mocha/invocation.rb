require 'mocha/raised_exception'

module Mocha
  class Invocation
    def initialize(yield_parameters, return_values)
      @yield_parameters = yield_parameters
      @return_values = return_values
    end

    def call
      @yield_parameters.next_invocation.each do |yield_parameters|
        yield(*yield_parameters)
      end
      @result = @return_values.next
    rescue Exception => e # rubocop:disable Lint/RescueException
      @result = RaisedException.new(e)
      raise
    end

    def mocha_inspect
      @result.mocha_inspect
    end
  end
end
