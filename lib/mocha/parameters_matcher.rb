require 'mocha/inspect'
require 'mocha/parameter_matchers'

module Mocha
  class ParametersMatcher
    def initialize(expected_parameters = [ParameterMatchers::AnyParameters.new], &matching_block)
      @expected_parameters = expected_parameters
      @matching_block = matching_block
    end

    def match?(invocation)
      actual_parameters = invocation.arguments
      if @matching_block
        # FUTURE: @matching_block.call(*invocation.positional_arguments, **invocation.keyword_arguments)
        @matching_block.call(*actual_parameters)
      else
        # FUTURE: check against invocation.positional_arguments and invocation.keyword_arguments
        parameters_match?(actual_parameters)
      end
    end

    def parameters_match?(actual_parameters)
      matchers.all? { |matcher| matcher.matches?(actual_parameters) } && actual_parameters.empty?
    end

    def mocha_inspect
      signature = matchers.mocha_inspect
      signature = signature.gsub(/^\[|\]$/, '')
      signature = signature.gsub(/^\{|\}$/, '') if matchers.length == 1
      "(#{signature})"
    end

    def matchers
      @expected_parameters.map(&:to_matcher)
    end
  end
end
