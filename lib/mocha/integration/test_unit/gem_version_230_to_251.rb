require 'test/unit/testcase'
require 'mocha/integration/test_unit/assertion_counter'
require 'mocha/expectation_error'

module Mocha

  module Integration

    module TestUnit

      module GemVersion230To251
        def self.included(mod)
          $stderr.puts "Monkey patching Test::Unit gem >= v2.3.0 and <= v2.5.1" if $mocha_options['debug']
          unless mod.ancestors.include?(Mocha::API)
            mod.send(:include, Mocha::API)
          end
          unless mod.method_defined?(:run_before_mocha)
            mod.send(:alias_method, :run_before_mocha, :run)
            mod.send(:remove_method, :run)
            mod.send(:include, InstanceMethods)
          end
        end
        module InstanceMethods
          def run(result)
            assertion_counter = AssertionCounter.new(result)
            begin
              @internal_data.test_started
              @_result = result
              yield(Test::Unit::TestCase::STARTED, name)
              yield(Test::Unit::TestCase::STARTED_OBJECT, self)
              begin
                begin
                  run_setup
                  run_test
                  run_cleanup
                  mocha_verify(assertion_counter)
                  add_pass
                rescue Mocha::ExpectationError => e
                  add_failure(e.message, e.backtrace)
                rescue Exception
                  @internal_data.interrupted
                  raise unless handle_exception($!)
                ensure
                  begin
                    run_teardown
                  rescue Exception
                    raise unless handle_exception($!)
                  end
                end
              ensure
                mocha_teardown
              end
              @internal_data.test_finished
              result.add_run
              yield(Test::Unit::TestCase::FINISHED, name)
              yield(Test::Unit::TestCase::FINISHED_OBJECT, self)
            ensure
              # @_result = nil # For test-spec's after_all :<
            end
          end
        end
      end

    end

  end

end
