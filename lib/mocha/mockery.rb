require 'mocha/central'
require 'mocha/mock'
require 'mocha/names'
require 'mocha/state_machine'

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
    
    def new_state_machine(name)
      add_state_machine(StateMachine.new(name))
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
    
    def mocks
      @mocks ||= []
    end
    
    def state_machines
      @state_machines ||= []
    end
    
    private
    
    def add_mock(mock)
      mocks << mock
      mock
    end
    
    def add_state_machine(state_machine)
      state_machines << state_machine
      state_machine
    end
    
    def reset
      @stubba = nil
      @mocks = nil
      @state_machines = nil
    end
    
  end
  
end