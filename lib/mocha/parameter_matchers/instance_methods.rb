# frozen_string_literal: true

require 'mocha/parameter_matchers/base'
require 'mocha/parameter_matchers/equals'
require 'mocha/parameter_matchers/positional_or_keyword_hash'

module Mocha
  module ParameterMatchers
    # @private
    module InstanceMethods
      # @private
      def to_matcher(expectation: nil, top_level: false, method_accepts_keyword_arguments: true)
        if Base === self
          self
        elsif Hash === self && (top_level || method_accepts_keyword_arguments)
          Mocha::ParameterMatchers::PositionalOrKeywordHash.new(self, expectation)
        else
          Mocha::ParameterMatchers::Equals.new(self)
        end
      end
    end
  end
end

# @private
class Object
  include Mocha::ParameterMatchers::InstanceMethods
end
