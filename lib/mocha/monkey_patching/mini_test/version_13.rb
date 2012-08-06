require 'mocha/monkey_patching/mini_test/assertion_counter'

module Mocha

  module MonkeyPatching

    module MiniTest

      module Version13
        def self.included(mod)
          $stderr.puts "Monkey patching MiniTest v1.3" if $mocha_options['debug']
        end
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
              result = runner.puke(self.class, self.name, Mocha::MonkeyPatching::MiniTest.translate(e))
            ensure
              begin
                self.teardown
              rescue Exception => e
                result = runner.puke(self.class, self.name, Mocha::MonkeyPatching::MiniTest.translate(e))
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
