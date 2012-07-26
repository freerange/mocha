require 'mocha_standalone'
require 'mocha/expectation_error'
require 'test/unit/assertionfailederror'

module Mocha
  module Integration
    module TestUnit

      class AssertionCounter
        def initialize(test_case)
          @test_case = test_case
        end

        def increment
          @test_case.assert(true)
        end
      end

      include Mocha::API

      def self.included(mod)
        Mocha::ExpectationErrorFactory.exception_class = Test::Unit::AssertionFailedError

        mod.setup :mocha_setup

        mod.cleanup do
          assertion_counter = AssertionCounter.new(self)
          mocha_verify(assertion_counter)
        end

        mod.teardown :mocha_teardown, after: :append
      end
    end
  end
end

