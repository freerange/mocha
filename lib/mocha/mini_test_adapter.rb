require 'mocha/expectation_error'

module Mocha

  module MiniTestCaseAdapter

    class AssertionCounter
      def initialize(runner)
        @runner = runner
      end

      def increment
        @runner.assertion_count += 1
      end
    end #AssertionCounter

    def self.included(base)
      base.class_eval do

        alias_method :run_before_mocha_mini_test_adapter, :run

        def run runner
          assertion_counter = AssertionCounter.new(runner)
          result = '.'
          begin
            begin
              @passed = nil
              self.setup
              self.__send__ self.name
              mocha_verify(assertion_counter)
              @passed = true
            rescue Exception => e
              @passed = false
              result = runner.puke(self.class, self.name, e)
            ensure
              begin
                self.teardown
              rescue Exception => e
                result = runner.puke(self.class, self.name, e)
              end
            end
          ensure
            mocha_teardown
          end
          result
        end

      end
    end

  end #MiniTestCaseAdapter
end
