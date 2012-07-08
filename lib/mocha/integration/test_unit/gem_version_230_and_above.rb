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

            cleanup :after => :append
            def cleanup_mocha
              begin
                assertion_counter = AssertionCounter.new(current_result)
                mocha_verify(assertion_counter)
              rescue Mocha::ExpectationError => e
                add_failure(e.message, e.backtrace)
              end
            end

            teardown :after => :append
            def teardown_mocha
              mocha_teardown
            end
          end
        end
      end

    end

  end

end
