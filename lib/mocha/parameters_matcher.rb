require 'mocha/inspect'
require 'mocha/parameter_matchers'
require 'mocha/parameter_matchers/last_positional_hash'

module Mocha
  class ParametersMatcher
    def initialize(expected_parameters = [ParameterMatchers::AnyParameters.new], &matching_block)
      @expected_parameters = expected_parameters
      @matching_block = matching_block
    end

    def match?(actual_parameters = [])
      if @matching_block
        @matching_block.call(*actual_parameters)
      else
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
      if (last_parameter = @expected_parameters.last).is_a?(Hash)
        @expected_parameters[0...-1].map(&:to_matcher) + [ParameterMatchers::LastPositionalHash.new(last_parameter)]
      else
        @expected_parameters.map(&:to_matcher)
      end
    end
  end
end
