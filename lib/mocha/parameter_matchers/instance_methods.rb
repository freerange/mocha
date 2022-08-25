require 'mocha/parameter_matchers/equals'

module Mocha
  module ParameterMatchers
    # @private
    module InstanceMethods
      # @private
      def to_matcher(*)
        Mocha::ParameterMatchers::Equals.new(self)
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
  def to_matcher(last_argument: false)
    return Mocha::ParameterMatchers::LastPositionalHash.new(self) if last_argument

    super
  end
end

