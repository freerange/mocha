require 'mocha/parameter_matchers/equals'
require 'mocha/parameter_matchers/hash'

module Mocha
  module ParameterMatchers
    # @private
    module InstanceMethods
      # @private
      def to_matcher
        Mocha::ParameterMatchers::Equals.new(self)
      end
    end
  end
end

# @private
class Object
  include Mocha::ParameterMatchers::InstanceMethods
end

class Hash
  def to_matcher
    Mocha::ParameterMatchers::Hash.new(self)
  end
end
