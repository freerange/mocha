module Mocha

  class StateMachine
  
    class State
    
      def initialize(state_machine, state)
        @state_machine, @state = state_machine, state
      end
    
      def activate
        @state_machine.current_state = @state
      end
    
      def active?
        @state_machine.current_state == @state
      end
    
      def mocha_inspect
        "#{@state_machine.name} is #{@state.mocha_inspect}"
      end
    
    end
  
    attr_reader :name
  
    attr_accessor :current_state
  
    def initialize(name)
      @name = name
      @current_state = nil
    end
  
    def starts_as(initial_state)
      @current_state = initial_state
      self
    end
  
    def is(state)
      State.new(self, state)
    end
  
    def mocha_inspect
      if @current_state
        "#{@name} is #{@current_state.mocha_inspect}"
      else
        "#{@name} has no current state"
      end
    end
  
  end

end