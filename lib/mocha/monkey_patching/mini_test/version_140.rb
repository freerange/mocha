require 'mocha/monkey_patching/mini_test/assertion_counter'
require 'mocha/expectation_error'

module Mocha

  module MonkeyPatching

    module MiniTest

      module Version140
        def self.included(mod)
          $stderr.puts "Monkey patching MiniTest v1.4.0" if $mocha_options['debug']
        end
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
              result = runner.puke(self.class, self.__name__, Mocha::MonkeyPatching::MiniTest.translate(e))
            ensure
              begin
                self.teardown
              rescue Exception => e
                result = runner.puke(self.class, self.__name__, Mocha::MonkeyPatching::MiniTest.translate(e))
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
