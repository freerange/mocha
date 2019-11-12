require 'mocha/parameters_matcher'
require 'mocha/raised_exception'
require 'mocha/return_values'
require 'mocha/thrown_object'
require 'mocha/yield_parameters'

module Mocha
  class Invocation
    attr_reader :method_name

    def initialize(mock, method_name, *arguments)
      @mock = mock
      @method_name = method_name
      @arguments = arguments
      @yields = []
      @result = nil
    end

    def call(yield_parameters = YieldParameters.new, return_values = ReturnValues.new)
      yield_parameters.next_invocation.each do |yield_args|
        @yields << ParametersMatcher.new(yield_args)
        yield(*yield_args)
      end
      return_values.next(self)
    end

    def returned(value)
      @result = value
    end

    def raised(exception)
      @result = RaisedException.new(exception)
    end

    def threw(tag, value)
      @result = ThrownObject.new(tag, value)
    end

    def arguments
      @arguments.dup
    end

    def mocha_inspect
      desc = "\n  - #{@mock.mocha_inspect}.#{@method_name}#{ParametersMatcher.new(@arguments).mocha_inspect}"
      desc << " # => #{@result.mocha_inspect}"
      desc << " after yielding #{@yields.map(&:mocha_inspect).join(', then ')}" if @yields.any?
      desc
    end
  end
end
