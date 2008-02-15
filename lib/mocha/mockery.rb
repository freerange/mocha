require 'mocha/central'
require 'mocha/mock'
require 'mocha/names'

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
    
    def named_mock(name, &block)
      add_mock(Mock.new(Name.new(name), &block))
    end
    
    def unnamed_mock(&block)
      add_mock(Mock.new(&block))
    end
    
    def mock_impersonating(object, &block)
      add_mock(Mock.new(ImpersonatingName.new(object), &block))
    end
    
    def mock_impersonating_any_instance_of(klass, &block)
      add_mock(Mock.new(ImpersonatingAnyInstanceName.new(klass), &block))
    end
    
    def verify(assertion_counter = nil)
      mocks.each { |mock| mock.verify(assertion_counter) }
    end
    
    def teardown
      stubba.unstub_all
      reset
    end
    
    def stubba
      @stubba ||= Central.new
    end
    
    private
    
    def mocks
      @mocks ||= []
    end
    
    def add_mock(mock)
      mocks << mock
      mock
    end
    
    def reset
      @mocks = nil
      @stubba = nil
    end
    
  end
  
end