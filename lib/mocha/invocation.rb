require 'mocha/parameters_matcher'
require 'mocha/raised_exception'
require 'mocha/return_values'
require 'mocha/thrown_object'
require 'mocha/yield_parameters'

module Mocha
  class Invocation
    attr_reader :method_name

    def initialize(mock, method_name, *arguments, &block)
      @mock = mock
      @method_name = method_name
      @arguments = arguments
      @block = block
      @yields = []
      @result = nil
    end

    def call(yield_parameters = YieldParameters.new, return_values = ReturnValues.new)
      yield_parameters.next_invocation.each do |yield_args|
        @yields << ParametersMatcher.new(yield_args)
        raise LocalJumpError unless @block
        @block.call(*yield_args)
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

    def call_description
      "#{@mock.mocha_inspect}.#{@method_name}#{ParametersMatcher.new(@arguments).mocha_inspect}"
    end

    def short_call_description
      "#{@method_name}(#{@arguments.join(', ')})"
    end

    def result_description
      desc = "# => #{@result.mocha_inspect}"
      desc << " after yielding #{@yields.map(&:mocha_inspect).join(', then ')}" if @yields.any?
      desc
    end

    def full_description
      "\n  - #{call_description} #{result_description}"
    end
  end
end
