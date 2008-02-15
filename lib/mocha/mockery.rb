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
      add_mock(Mock.named(name, &block))
    end
    
    def unnamed_mock(&block)
      add_mock(Mock.unnamed(&block))
    end
    
    def mock_impersonating(object, &block)
      add_mock(Mock.impersonating(object, &block))
    end
    
    def mock_impersonating_any_instance_of(klass, &block)
      add_mock(Mock.impersonating_any_instance_of(klass, &block))
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
    
    def add_mock(mock)
      @mocks << mock
      mock
    end
    
    def reset
      @mocks = []
      @stubba = Central.new
    end
    
  end
  
end