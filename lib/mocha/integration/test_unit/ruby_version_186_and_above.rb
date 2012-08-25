require 'test/unit/testcase'
require 'mocha/integration/test_unit/assertion_counter'
require 'mocha/expectation_error'

module Mocha

  module Integration

    module TestUnit

      module RubyVersion186AndAbove
        def self.included(mod)
          $stderr.puts "Monkey patching Test::Unit for Ruby >= v1.8.6" if $mocha_options['debug']
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
            yield(Test::Unit::TestCase::STARTED, name)
            @_result = result
            begin
              begin
                setup
                __send__(@method_name)
                mocha_verify(assertion_counter)
              rescue Mocha::ExpectationError => e
                add_failure(e.message, e.backtrace)
              rescue Test::Unit::AssertionFailedError => e
                add_failure(e.message, e.backtrace)
              rescue Exception
                raise if Test::Unit::TestCase::PASSTHROUGH_EXCEPTIONS.include? $!.class
                add_error($!)
              ensure
                begin
                  teardown
                rescue Mocha::ExpectationError => e
                  add_failure(e.message, e.backtrace)
                rescue Test::Unit::AssertionFailedError => e
                  add_failure(e.message, e.backtrace)
                rescue Exception
                  raise if Test::Unit::TestCase::PASSTHROUGH_EXCEPTIONS.include? $!.class
                  add_error($!)
                end
              end
            ensure
              mocha_teardown
            end
            result.add_run
            yield(Test::Unit::TestCase::FINISHED, name)
          end
        end
      end

    end

  end

end
