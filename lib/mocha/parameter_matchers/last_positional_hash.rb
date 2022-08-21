require 'mocha/parameter_matchers/base'
require 'mocha/ruby_version'

module Mocha
  module ParameterMatchers
    # @private
    class LastPositionalHash < Base
      def initialize(value)
        @value = value
      end

      def matches?(available_parameters)
        parameter = available_parameters.shift
        if RUBY_V3_PLUS
          return false if Hash.ruby2_keywords_hash?(@value) && !Hash.ruby2_keywords_hash?(parameter)
        end

        parameter == @value
      end

      def mocha_inspect
        @value.mocha_inspect
      end
    end
  end
end
