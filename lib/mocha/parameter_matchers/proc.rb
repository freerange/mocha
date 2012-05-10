module Mocha

  module ParameterMatchers

    # Parameter matcher which matches when proc returns truthy when given actual parameter.
    class Proc < Base

      # @private
      def initialize(_proc)
        @_proc = _proc
      end

      # @private
      def matches?(available_parameters)
        parameter = available_parameters.shift
        @_proc.call(parameter)
      end

      # @private
      def mocha_inspect
        "proc"
      end

    end
  end

  module ProcMethods
    # @private
    def to_matcher
      Mocha::ParameterMatchers::Proc.new(self)
    end
  end
end

# @private
class Proc
  include Mocha::ProcMethods
end
