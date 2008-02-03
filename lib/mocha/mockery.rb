require 'mocha/central'
require 'mocha/mock'

module Mocha
  
  class Mockery
    
    def named_mock(name, &block)
      mock = Mock.named(name, &block)
      @mocks << mock
      mock
    end
    
    def unnamed_mock(&block)
      mock = Mock.unnamed(&block)
      @mocks << mock
      mock
    end
  
    def initialize
      @mocks = []
      $stubba = Mocha::Central.new
    end
    
    def verify(assertion_counter = nil)
      @mocks.each { |mock| mock.verify(assertion_counter) }
      $stubba.verify_all(assertion_counter) if $stubba
    end
    
    def teardown
      if $stubba then
        $stubba.unstub_all
        $stubba = nil
      end
    end
    
  end
  
end