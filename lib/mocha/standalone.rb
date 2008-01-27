require 'mocha/auto_verify'
require 'mocha/parameter_matchers'
require 'mocha/setup_and_teardown'

module Mocha
  
  module Standalone
    
    include AutoVerify
    include ParameterMatchers
    include SetupAndTeardown
    
    def mocha_setup
      setup_stubs
    end
    
    def mocha_verify(assertion_counter = nil)
      verify_mocks(assertion_counter)
      verify_stubs(assertion_counter)
    end
    
    def mocha_teardown
      begin
        teardown_mocks
      ensure
        teardown_stubs
      end
    end
    
  end
  
end