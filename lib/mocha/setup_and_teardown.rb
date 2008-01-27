require 'mocha/central'

module Mocha
  
  module SetupAndTeardown
  
    def setup_stubs
      $stubba = Mocha::Central.new
    end
    
    def verify_stubs(assertion_counter = nil)
      $stubba.verify_all(assertion_counter) if $stubba
    end
  
    def teardown_stubs
      if $stubba then
        $stubba.unstub_all
        $stubba = nil
      end
    end

  end
end