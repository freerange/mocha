require 'mocha/parameter_matchers/equals'
require 'mocha/parameter_matchers/positional_or_keyword_hash'

module Mocha
  module ParameterMatchers
    # @private
    module InstanceMethods
      # @private
      def to_matcher(_expectation = nil, _method_accepts_keyword_arguments = true)
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
  def to_matcher(expectation = nil, method_accepts_keyword_arguments = true)
    if method_accepts_keyword_arguments
      Mocha::ParameterMatchers::PositionalOrKeywordHash.new(self, expectation)
    else
      Mocha::ParameterMatchers::Equals.new(self)
    end
  end
end
