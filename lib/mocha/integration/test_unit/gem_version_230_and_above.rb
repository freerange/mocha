require 'test/unit/testcase'
require 'mocha/integration/test_unit/assertion_counter'
require 'mocha/expectation_error'

module Mocha

  module Integration

    module TestUnit

      module GemVersion230AndAbove
        def self.included(mod)
          mod.module_eval do
            alias_method :run, :run_before_mocha

            exception_handler(:handle_mocha_expectation_error)

            cleanup :cleanup_mocha, :after => :append
            teardown :teardown_mocha, :after => :append
          end
        end

        private
        def cleanup_mocha
          assertion_counter = AssertionCounter.new(current_result)
          mocha_verify(assertion_counter)
        end

        def teardown_mocha
          mocha_teardown
        end

        def handle_mocha_expectation_error(exception)
          return false unless exception.is_a?(Mocha::ExpectationError)
          problem_occurred
          add_failure(exception.message, exception.backtrace)
          true
        end
      end

    end

  end

end
