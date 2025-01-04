# frozen_string_literal: true

require 'mocha/parameter_matchers/base'
require 'mocha/parameter_matchers/equals'
require 'mocha/parameter_matchers/positional_or_keyword_hash'

module Mocha
  module ParameterMatchers
    # @private
    module InstanceMethods
      # @private
      def to_matcher(expectation: nil, top_level: false, last: false)
        if Base === self
          self
        elsif Hash === self && top_level
          Mocha::ParameterMatchers::PositionalOrKeywordHash.new(self, expectation, last)
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
