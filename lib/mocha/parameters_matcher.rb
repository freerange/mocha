require 'mocha/inspect'
require 'mocha/parameter_matchers'

module Mocha
  class ParametersMatcher
    def initialize(expected_parameters = [ParameterMatchers::AnyParameters.new], expectation = nil, &matching_block)
      @expected_parameters = expected_parameters
      @expectation = expectation
      @matching_block = matching_block
    end

    def match?(invocation)
      actual_parameters = invocation.arguments || []
      if @matching_block
        @matching_block.call(*actual_parameters)
      else
        matchers(invocation).all? { |matcher| matcher.matches?(actual_parameters) } && actual_parameters.empty?
      end
    end

    def mocha_inspect
      signature = matchers.mocha_inspect
      signature = signature.gsub(/^\[|\]$/, '')
      "(#{signature})"
    end

    def matchers(invocation)
      @expected_parameters.map { |p| p.to_matcher(@expectation, invocation.method_accepts_keyword_arguments?) }
    end
  end
end
