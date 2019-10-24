require 'mocha/parameters_matcher'
require 'mocha/raised_exception'

module Mocha
  class Invocation
    def initialize(yield_parameters, return_values)
      @yield_parameters = yield_parameters
      @return_values = return_values
      @yields = []
    end

    def call
      @yield_parameters.next_invocation.each do |yield_parameters|
        @yields << ParametersMatcher.new(yield_parameters)
        yield(*yield_parameters)
      end
      @result = @return_values.next
    rescue Exception => e # rubocop:disable Lint/RescueException
      @result = RaisedException.new(e)
      raise
    end

    def mocha_inspect
      desc = @result.mocha_inspect
      desc << " after yielding #{@yields.map(&:mocha_inspect).join(', then ')}" if @yields.any?
      desc
    end
  end
end
