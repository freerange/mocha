require 'mocha/parameter_matchers'
require 'mocha/hooks'
require 'mocha/mockery'
require 'mocha/sequence'
require 'mocha/object_methods'
require 'mocha/class_methods'

module Mocha
  # Methods added to +Test::Unit::TestCase+, +MiniTest::Unit::TestCase+ or equivalent.
  # The mock creation methods are {#mock}, {#stub} and {#stub_everything}, all of which return a #{Mock}
  # which can be further modified by {Mock#responds_like} and {Mock#responds_like_instance_of} methods,
  # both of which return a {Mock}, too, and can therefore, be chained to the original creation methods.
  #
  # {Mock#responds_like} and {Mock#responds_like_instance_of} force the mock to indicate what it is
  # supposed to be mocking, thus making it a safer verifying mock. They check that the underlying +responder+
  # will actually respond to the methods being stubbed, throwing a +NoMethodError+ upon invocation otherwise.
  #
  # @example Verifying mock using {Mock#responds_like_instance_of}
  #   class Sheep
  #     def initialize
  #       raise "some awkward code we don't want to call"
  #     end
  #     def chew(grass); end
  #   end
  #
  #   sheep = mock('sheep').responds_like_instance_of(Sheep)
  #   sheep.expects(:chew)
  #   sheep.expects(:foo)
  #   sheep.respond_to?(:chew) # => true
  #   sheep.respond_to?(:foo) # => false
  #   sheep.chew
  #   sheep.foo # => raises NoMethodError exception
  module API
    include ParameterMatchers
    include Hooks

    # @private
    def self.included(_mod)
      Object.send(:include, Mocha::ObjectMethods)
      Class.send(:include, Mocha::ClassMethods)
    end

    # Builds a new mock object
    #
    # @param [String, Symbol] name identifies mock object in error messages.
    # @param [Hash] expected_methods_vs_return_values expected method name symbols as keys and corresponding return values as values - these expectations are setup as if {Mock#expects} were called multiple times.
    # @return [Mock] a new mock object
    #
    # @overload def mock(name)
    # @overload def mock(expected_methods_vs_return_values = {})
    # @overload def mock(name, expected_methods_vs_return_values = {})
    #
    # @example Using expected_methods_vs_return_values Hash to setup expectations.
    #   def test_motor_starts_and_stops
    #     motor = mock('motor', :start => true, :stop => true)
    #     assert motor.start
    #     assert motor.stop
    #     # an error will be raised unless both Motor#start and Motor#stop have been called
    #   end
    def mock(*arguments)
      create_mock(arguments) { |mock, expectations| mock.expects(expectations) }
    end

    # Builds a new mock object
    #
    # @param [String, Symbol] name identifies mock object in error messages.
    # @param [Hash] stubbed_methods_vs_return_values stubbed method name symbols as keys and corresponding return values as values - these stubbed methods are setup as if {Mock#stubs} were called multiple times.
    # @return [Mock] a new mock object
    #
    # @overload def stub(name)
    # @overload def stub(stubbed_methods_vs_return_values = {})
    # @overload def stub(name, stubbed_methods_vs_return_values = {})
    #
    # @example Using stubbed_methods_vs_return_values Hash to setup stubbed methods.
    #   def test_motor_starts_and_stops
    #     motor = stub('motor', :start => true, :stop => true)
    #     assert motor.start
    #     assert motor.stop
    #     # an error will not be raised even if either Motor#start or Motor#stop has not been called
    #   end
    def stub(*arguments)
      create_mock(arguments) { |stub, expectations| stub.stubs(expectations) }
    end

    # Builds a mock object that accepts calls to any method. By default it will return +nil+ for any method call.
    #
    # @param [String, Symbol] name identifies mock object in error messages.
    # @param [Hash] stubbed_methods_vs_return_values stubbed method name symbols as keys and corresponding return values as values - these stubbed methods are setup as if {Mock#stubs} were called multiple times.
    # @return [Mock] a new mock object
    #
    # @overload def stub_everything(name)
    # @overload def stub_everything(stubbed_methods_vs_return_values = {})
    # @overload def stub_everything(name, stubbed_methods_vs_return_values = {})
    #
    # @example Ignore invocations of irrelevant methods.
    #   def test_motor_stops
    #     motor = stub_everything('motor', :stop => true)
    #     assert_nil motor.irrelevant_method_1 # => no error raised
    #     assert_nil motor.irrelevant_method_2 # => no error raised
    #     assert motor.stop
    #   end
    def stub_everything(*arguments)
      create_mock(arguments) do |stub, expectations|
        stub.stub_everything
        stub.stubs(expectations)
      end
    end

    # Builds a new sequence which can be used to constrain the order in which expectations can occur.
    #
    # Specify that an expected invocation must occur within a named {Sequence} by using {Expectation#in_sequence}.
    #
    # @return [Sequence] a new sequence
    #
    # @see Expectation#in_sequence
    #
    # @example Ensure methods on egg are invoked in correct order.
    #   breakfast = sequence('breakfast')
    #
    #   egg = mock('egg') do
    #     expects(:crack).in_sequence(breakfast)
    #     expects(:fry).in_sequence(breakfast)
    #     expects(:eat).in_sequence(breakfast)
    #   end
    def sequence(name)
      Sequence.new(name)
    end

    # Builds a new state machine which can be used to constrain the order in which expectations can occur.
    #
    # Specify the initial state of the state machine by using {StateMachine#starts_as}.
    #
    # Specify that an expected invocation should change the state of the state machine by using {Expectation#then}.
    #
    # Specify that an expected invocation should be constrained to occur within a particular +state+ by using {Expectation#when}.
    #
    # A test can contain multiple state machines.
    #
    # @return [StateMachine] a new state machine
    #
    # @see Expectation#then
    # @see Expectation#when
    # @see StateMachine
    # @example Constrain expected invocations to occur in particular states.
    #   power = states('power').starts_as('off')
    #
    #   radio = mock('radio') do
    #     expects(:switch_on).then(power.is('on'))
    #     expects(:select_channel).with('BBC Radio 4').when(power.is('on'))
    #     expects(:adjust_volume).with(+5).when(power.is('on'))
    #     expects(:select_channel).with('BBC World Service').when(power.is('on'))
    #     expects(:adjust_volume).with(-5).when(power.is('on'))
    #     expects(:switch_off).then(power.is('off'))
    #   end
    def states(name)
      Mockery.instance.new_state_machine(name)
    end

    private

    def create_mock(arguments)
      name = arguments.shift.to_s if arguments.first.is_a?(String) || arguments.first.is_a?(Symbol)
      expectations = arguments.shift || {}
      mock = name ? Mockery.instance.named_mock(name) : Mockery.instance.unnamed_mock
      yield mock, expectations
      mock
    end
  end
end
