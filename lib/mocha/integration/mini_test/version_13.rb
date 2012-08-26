require 'mocha/integration/mini_test/assertion_counter'
require 'mocha/integration/mini_test/exception_translation'
require 'mocha/integration/monkey_patcher'

module Mocha

  module Integration

    module MiniTest

      module Version13
        def self.description
          "monkey patch for MiniTest gem v1.3"
        end
        def self.included(mod)
          MonkeyPatcher.apply(mod, RunMethodPatch)
        end
        module RunMethodPatch
          def run runner
            assertion_counter = AssertionCounter.new(self)
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
                result = runner.puke(self.class, self.name, Mocha::Integration::MiniTest.translate(e))
              ensure
                begin
                  self.teardown
                rescue Exception => e
                  result = runner.puke(self.class, self.name, Mocha::Integration::MiniTest.translate(e))
                end
              end
            ensure
              mocha_teardown
            end
            result
          end
        end
      end

    end

  end

end
