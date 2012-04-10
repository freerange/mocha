require 'mocha/parameter_matchers/base'

module Mocha

  module ParameterMatchers

    # Matches any object that responds with +true+ to +include?(item)+.
    #
    # @param [Object] item expected item.
    # @return [Includes] parameter matcher.
    #
    # @see Expectation#with
    #
    # @example Actual parameter includes item.
    #   object = mock()
    #   object.expects(:method_1).with(includes('foo'))
    #   object.method_1(['foo', 'bar'])
    #   # no error raised
    #
    # @example Actual parameter does not include item.
    #   object.method_1(['baz'])
    #   # error raised, because ['baz'] does not include 'foo'.
    def includes(item)
      Includes.new(item)
    end

    # Parameter matcher which matches when actual parameter includes expected value.
    class Includes < Base

      # @private
      def initialize(item)
        @item = item
      end

      # @private
      def matches?(available_parameters)
        parameter = available_parameters.shift
        return false unless parameter.respond_to?(:include?)
        return parameter.include?(@item)
      end

      # @private
      def mocha_inspect
        "includes(#{@item.mocha_inspect})"
      end

    end

  end

end
