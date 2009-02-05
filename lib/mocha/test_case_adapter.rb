require 'mocha/expectation_error'

module Mocha
  
  module TestCaseAdapter
    
    class AssertionCounter
      
      def initialize(test_result)
        @test_result = test_result
      end
      
      def increment
        @test_result.add_assertion
      end
      
    end
    
    def self.included(base)
      if Mocha.test_unit_version == '2.0.0'
        base.class_eval do
          
          alias_method :run_before_mocha_test_case_adapter, :run
          
          def run(result)
            assertion_counter = AssertionCounter.new(result)
            begin
              @_result = result
              yield(Test::Unit::TestCase::STARTED, name)
              begin
                begin
                  run_setup
                  __send__(@method_name)
                  mocha_verify(assertion_counter)
                rescue Mocha::ExpectationError => e
                  add_failure(e.message, e.backtrace)
                rescue Exception
                  @interrupted = true
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
              result.add_run
              yield(Test::Unit::TestCase::FINISHED, name)
            ensure
              @_result = nil
            end
          end
        end
        
        elsif Mocha.test_unit_version >= '2.0.1'
          base.class_eval do

            alias_method :run_before_mocha_test_case_adapter, :run

            def run(result)
              assertion_counter = AssertionCounter.new(result)
              begin
                @_result = result
                yield(Test::Unit::TestCase::STARTED, name)
                begin
                  begin
                    run_setup
                    run_test
                    mocha_verify(assertion_counter)
                  rescue Mocha::ExpectationError => e
                    add_failure(e.message, e.backtrace)
                  rescue Exception
                    @interrupted = true
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
                result.add_run
                yield(Test::Unit::TestCase::FINISHED, name)
              ensure
                @_result = nil
              end
            end
          end

      elsif RUBY_VERSION < '1.8.6'
        base.class_eval do

          alias_method :run_before_mocha_test_case_adapter, :run

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
              rescue StandardError, ScriptError
                add_error($!)
              ensure
                begin
                  teardown
                rescue Test::Unit::AssertionFailedError => e
                  add_failure(e.message, e.backtrace)
                rescue StandardError, ScriptError
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
      else
        base.class_eval do

          alias_method :run_before_mocha_test_case_adapter, :run

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
  
  private
  
  def self.test_unit_version
    require 'test/unit/version'
    Test::Unit::VERSION
  rescue LoadError
    '1.x'
  end

end