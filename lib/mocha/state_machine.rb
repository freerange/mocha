module Mocha # :nodoc:

  # A state machine that is used to constrain the order of invocations.
  # An invocation can be constrained to occur when a state is, or is not, active.
  class StateMachine
  
    class State # :nodoc:
    
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
    
    class StatePredicate # :nodoc:
      
      def initialize(state_machine, state)
        @state_machine, @state = state_machine, state
      end
    
      def active?
        @state_machine.current_state != @state
      end
    
      def mocha_inspect
        "#{@state_machine.name} is not #{@state.mocha_inspect}"
      end
      
    end
    
    attr_reader :name # :nodoc:
    
    attr_accessor :current_state # :nodoc:
    
    def initialize(name) # :nodoc:
      @name = name
      @current_state = nil
    end
    
    # :call-seq: starts_as(initial_state) -> state_machine
    #
    # Put the +state_machine+ into the +initial_state+.
    def starts_as(initial_state)
      @current_state = initial_state
      self
    end
  
    def is(state) # :nodoc:
      State.new(self, state)
    end
  
    def is_not(state) # :nodoc:
      StatePredicate.new(self, state)
    end
  
    def mocha_inspect # :nodoc:
      if @current_state
        "#{@name} is #{@current_state.mocha_inspect}"
      else
        "#{@name} has no current state"
      end
    end
  
  end

end