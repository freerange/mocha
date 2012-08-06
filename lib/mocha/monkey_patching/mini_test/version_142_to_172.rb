require 'mocha/monkey_patching/mini_test/assertion_counter'
require 'mocha/expectation_error'

module Mocha

  module MonkeyPatching

    module MiniTest

      module Version142To172
        def self.included(mod)
          $stderr.puts "Monkey patching MiniTest >= v1.4.2 and <= v1.7.2" if $mocha_options['debug']
        end
        def run runner
          trap 'INFO' do
            warn '%s#%s %.2fs' % [self.class, self.__name__,
              (Time.now - runner.start_time)]
            runner.status $stderr
          end if ::MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL

          assertion_counter = AssertionCounter.new(self)
          result = '.'
          begin
            begin
              @passed = nil
              self.setup
              self.__send__ self.__name__
              mocha_verify(assertion_counter)
              @passed = true
            rescue *::MiniTest::Unit::TestCase::PASSTHROUGH_EXCEPTIONS
              raise
            rescue Exception => e
              @passed = false
              result = runner.puke(self.class, self.__name__, Mocha::MonkeyPatching::MiniTest.translate(e))
            ensure
              begin
                self.teardown
              rescue *::MiniTest::Unit::TestCase::PASSTHROUGH_EXCEPTIONS
                raise
              rescue Exception => e
                result = runner.puke(self.class, self.__name__, Mocha::MonkeyPatching::MiniTest.translate(e))
              end
              trap 'INFO', 'DEFAULT' if ::MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL
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
