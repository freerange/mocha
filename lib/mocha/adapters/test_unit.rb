require 'mocha_standalone'
require 'mocha/expectation_error'

module Mocha
  module Adapters
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

      def self.applicable_to?(test_unit_version, ruby_version)
        Gem::Requirement.new('>= 2.5.1').satisfied_by?(test_unit_version)
      end

      def self.description
        "adapter for Test::Unit gem >= v2.5.1"
      end

      def self.included(mod)
        mod.setup :mocha_setup, :before => :prepend

        mod.exception_handler(:handle_mocha_expectation_error)

        mod.cleanup :after => :append do
          assertion_counter = AssertionCounter.new(self)
          mocha_verify(assertion_counter)
        end

        mod.teardown :mocha_teardown, :after => :append
      end

      private

      def handle_mocha_expectation_error(e)
        return false unless e.is_a?(Mocha::ExpectationError)
        problem_occurred
        add_failure(e.message, e.backtrace)
        true
      end
    end
  end
end
