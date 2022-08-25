require 'mocha/parameter_matchers/equals'

module Mocha
  module ParameterMatchers
    # @private
    module InstanceMethods
      # @private
      def to_matcher
        Mocha::ParameterMatchers::Equals.new(self)
      end

      def mark_last_argument
        @is_last_argument = true
      end

      def is_last_argument?
        !!@is_last_argument
      end
    end
  end
end

# @private
class Object
  include Mocha::ParameterMatchers::InstanceMethods
end

# @private
class Hash
  # @private
  def to_matcher
    return Mocha::ParameterMatchers::LastPositionalHash.new(self) if is_last_argument?

    super
  end
end

