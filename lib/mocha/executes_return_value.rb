# frozen_string_literal: true

module Mocha
  class ExecutesReturnValue
    def initialize(implementation)
      @implementation = implementation
    end

    def evaluate(invocation)
      result = @implementation.call(*invocation.arguments, &invocation.block)
      invocation.returned(result)
      result
    rescue Exception => e # rubocop:disable Lint/RescueException
      invocation.raised(e)
      raise
    end
  end
end
