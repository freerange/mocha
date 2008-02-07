require 'mocha/central'
require 'mocha/mock'

module Mocha
  
  class Mockery
    
    class << self
      
      def instance
        @instance ||= new
      end
      
      def reset_instance
        @instance = nil
      end
      
    end
    
    attr_accessor :stubba
    
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
    
    def mock_impersonating(object, &block)
      mock = Mock.impersonating(object, &block)
      @mocks << mock
      mock
    end
    
    def mock_impersonating_any_instance_of(klass, &block)
      mock = Mock.impersonating_any_instance_of(klass, &block)
      @mocks << mock
      mock
    end
    
    def initialize
      reset
    end
    
    def verify(assertion_counter = nil)
      @mocks.each { |mock| mock.verify(assertion_counter) }
    end
    
    def teardown
      @stubba.unstub_all
      reset
    end
    
    private
    
    def reset
      @mocks = []
      @stubba = Central.new
    end
    
  end
  
end