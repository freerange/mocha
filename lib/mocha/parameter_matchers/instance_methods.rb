require 'mocha/parameter_matchers/equals'
require 'mocha/parameter_matchers/positional_or_keyword_hash'

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

# @private
class Hash
  # @private
  def to_matcher
    Mocha::ParameterMatchers::PositionalOrKeywordHash.new(self)
  end
end
