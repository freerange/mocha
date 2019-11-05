require 'mocha/parameters_matcher'
require 'mocha/raised_exception'
require 'mocha/return_values'
require 'mocha/thrown_object'
require 'mocha/yield_parameters'

module Mocha
  class Invocation
    # @private
    def initialize(method_name, yield_parameters = YieldParameters.new, return_values = ReturnValues.new)
      @method_name = method_name
      @yield_parameters = yield_parameters
      @return_values = return_values
      @yields = []
      @result = nil
    end

    # @private
    def call(*arguments)
      @arguments = ParametersMatcher.new(arguments)
      @yield_parameters.next_invocation.each do |yield_parameters|
        @yields << ParametersMatcher.new(yield_parameters)
        yield(*yield_parameters)
      end
      @return_values.next(self)
    end

    # @private
    def returned(value)
      @result = value
    end

    # @private
    def raised(exception)
      @result = RaisedException.new(exception)
    end

    # @private
    def threw(tag, value)
      @result = ThrownObject.new(tag, value)
    end

    # @private
    def mocha_inspect
      desc = "\n  - #{@method_name}#{@arguments.mocha_inspect} # => #{@result.mocha_inspect}"
      desc << " after yielding #{@yields.map(&:mocha_inspect).join(', then ')}" if @yields.any?
      desc
    end
  end
end
