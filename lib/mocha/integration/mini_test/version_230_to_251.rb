require 'mocha/integration/mini_test/assertion_counter'
require 'mocha/expectation_error'

module Mocha

  module Integration

    module MiniTest

      module Version230To251
        def self.included(mod)
          $stderr.puts "Monkey patching MiniTest >= v2.3.0 <= v2.5.1" if $options['debug']
        end
        def run runner
          trap 'INFO' do
            time = runner.start_time ? Time.now - runner.start_time : 0
            warn "%s#%s %.2fs" % [self.class, self.__name__, time]
            runner.status $stderr
          end if ::MiniTest::Unit::TestCase::SUPPORTS_INFO_SIGNAL

          assertion_counter = AssertionCounter.new(self)
          result = ""
          begin
            begin
              @passed = nil
              self.setup
              self.run_setup_hooks
              self.__send__ self.__name__
              mocha_verify(assertion_counter)
              result = "." unless io?
              @passed = true
            rescue *::MiniTest::Unit::TestCase::PASSTHROUGH_EXCEPTIONS
              raise
            rescue Exception => e
              @passed = false
              result = runner.puke self.class, self.__name__, Mocha::Integration::MiniTest.translate(e)
            ensure
              begin
                self.run_teardown_hooks
                self.teardown
              rescue *::MiniTest::Unit::TestCase::PASSTHROUGH_EXCEPTIONS
                raise
              rescue Exception => e
                result = runner.puke self.class, self.__name__, Mocha::Integration::MiniTest.translate(e)
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
