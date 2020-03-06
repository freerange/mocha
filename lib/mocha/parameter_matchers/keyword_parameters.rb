require 'mocha/parameter_matchers/base'
require 'mocha/parameter_matchers/has_entries'

module Mocha
  module ParameterMatchers
    # Parameter matcher which matches when actual +keyword parameters+ contain all expected entries.
    class KeywordParameters < Base
      # @private
      def initialize(entries)
        @entries = entries
      end

      # @private
      def matches?(available_parameters)
        parameter = available_parameters.shift
        @entries.size == parameter.size && HasEntries.new(@entries).matches?([parameter])
      end

      # @private
      def mocha_inspect
        @entries.mocha_inspect
      end
    end
  end
end
