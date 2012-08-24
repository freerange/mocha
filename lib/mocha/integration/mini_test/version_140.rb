require 'mocha/integration/mini_test/assertion_counter'
require 'mocha/integration/mini_test/exception_translation'

module Mocha

  module Integration

    module MiniTest

      module Version140
        def self.included(mod)
          $stderr.puts "Monkey patching MiniTest v1.4.0" if $mocha_options['debug']
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
          def run runner
            assertion_counter = AssertionCounter.new(self)
            result = '.'
            begin
              begin
                @passed = nil
                self.setup
                self.__send__ self.__name__
                mocha_verify(assertion_counter)
                @passed = true
              rescue Exception => e
                @passed = false
                result = runner.puke(self.class, self.__name__, Mocha::Integration::MiniTest.translate(e))
              ensure
                begin
                  self.teardown
                rescue Exception => e
                  result = runner.puke(self.class, self.__name__, Mocha::Integration::MiniTest.translate(e))
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
