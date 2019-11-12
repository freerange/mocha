require 'mocha/parameters_matcher'
require 'mocha/raised_exception'

module Mocha
  class Invocation
    attr_reader :method_name

    def initialize(mock, method_name, *arguments)
      @mock = mock
      @method_name = method_name
      @arguments = arguments
      @yields = []
    end

    def call(yield_parameters, return_values)
      yield_parameters.next_invocation.each do |yield_args|
        @yields << ParametersMatcher.new(yield_args)
        yield(*yield_args)
      end
      @result = return_values.next
    rescue Exception => e # rubocop:disable Lint/RescueException
      @result = RaisedException.new(e)
      raise
    end

    def arguments
      @arguments.dup
    end

    def full_description
      "#{@mock.mocha_inspect}.#{@method_name}#{ParametersMatcher.new(@arguments).mocha_inspect}"
    end

    def short_description
      "#{@method_name}(#{@arguments.join(', ')})"
    end

    def mocha_inspect
      desc = "\n  - #{@mock.mocha_inspect}.#{@method_name}#{ParametersMatcher.new(@arguments).mocha_inspect}"
      desc << " # => #{@result.mocha_inspect}"
      desc << " after yielding #{@yields.map(&:mocha_inspect).join(', then ')}" if @yields.any?
      desc
    end
  end
end
