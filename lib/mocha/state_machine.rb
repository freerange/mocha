module Mocha

  # A state machine that is used to constrain the order of invocations.
  # An invocation can be constrained to occur when a state {#is}, or {#is_not}, active.
  class StateMachine

    # Provides a mechanism to change the state of a {StateMachine} at some point in the future.
    class State

      # @private
      def initialize(state_machine, state)
        @state_machine, @state = state_machine, state
      end

      # @private
      def activate
        @state_machine.become(@state)
      end

      # @private
      def active?
        @state_machine.current_state == @state
      end

      # @private
      def mocha_inspect
        "#{@state_machine.name} is #{@state.mocha_inspect}"
      end

    end

    # Provides the ability to determine whether a {StateMachine} is in a specified state at some point in the future.
    class StatePredicate

      # @private
      def initialize(state_machine, state)
        @state_machine, @state = state_machine, state
      end

      # @private
      def active?
        @state_machine.current_state != @state
      end

      # @private
      def mocha_inspect
        "#{@state_machine.name} is not #{@state.mocha_inspect}"
      end

    end

    # @private
    attr_reader :name

    # @private
    attr_accessor :current_state

    # @private
    def initialize(name)
      @name = name
      @current_state = nil
      @enter_state_cb= {}
      @exit_state_cb= {}
    end

    # Put the {StateMachine} into the state specified by +initial_state_name+.
    #
    # @param [String] initial_state_name name of initial state
    # @return [StateMachine] state machine, thereby allowing invocations of other {StateMachine} methods to be chained.
    def starts_as(initial_state_name)
      become(initial_state_name)
      self
    end

    # Add enter_state callback.
    #
    # @param [String] state name of state
    def enter_state(state, &block)
      @enter_state_cb[state]||= []
      @enter_state_cb[state]<< block
    end

    # Add exit_state callback.
    #
    # @param [String] state name of state
    def exit_state(state, &block)
      @exit_state_cb[state]||= []
      @exit_state_cb[state]<< block
    end

    # Put the {StateMachine} into the +next_state_name+.
    #
    # @param [String] next_state_name name of new state
    def become(next_state_name)
      return if @current_state == next_state_name
      @exit_state_cb[@current_state].each(&:call) if @exit_state_cb.has_key?(@current_state)
      @current_state = next_state_name
      @enter_state_cb[@current_state].each(&:call) if @enter_state_cb.has_key?(@current_state)
    end

    # Provides a mechanism to change the {StateMachine} into the state specified by +state_name+ at some point in the future.
    #
    # Or provides a mechanism to determine whether the {StateMachine} is in the state specified by +state_name+ at some point in the future.
    #
    # @param [String] state_name name of new state
    # @return [State] state which, when activated, will change the {StateMachine} into the state with the specified +state_name+.
    def is(state_name)
      State.new(self, state_name)
    end

    # Provides a mechanism to determine whether the {StateMachine} is not in the state specified by +state_name+ at some point in the future.
    def is_not(state_name)
      StatePredicate.new(self, state_name)
    end

    # @private
    def mocha_inspect
      if @current_state
        "#{@name} is #{@current_state.mocha_inspect}"
      else
        "#{@name} has no current state"
      end
    end

  end

end
