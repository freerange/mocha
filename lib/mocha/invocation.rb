require 'mocha/parameters_matcher'
require 'mocha/raised_exception'

module Mocha
  class Invocation
    attr_reader :method_name, :arguments

    def initialize(method_name, *arguments)
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

    def mocha_inspect
      desc = "\n  - #{@method_name}#{ParametersMatcher.new(@arguments).mocha_inspect} # => #{@result.mocha_inspect}"
      desc << " after yielding #{@yields.map(&:mocha_inspect).join(', then ')}" if @yields.any?
      desc
    end
  end
end
