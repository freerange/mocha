# frozen_string_literal: true

require 'mocha/central'
require 'mocha/mock'
require 'mocha/name'
require 'mocha/impersonating_name'
require 'mocha/impersonating_any_instance_name'
require 'mocha/object_receiver'
require 'mocha/any_instance_receiver'
require 'mocha/state_machine'
require 'mocha/logger'
require 'mocha/configuration'
require 'mocha/stubbing_error'
require 'mocha/not_initialized_error'
require 'mocha/expectation_error_factory'

module Mocha
  class Mockery
    class Null < self
      def self.build
        new(nil)
      end

      def add_mock(*)
        raise_not_initialized_error
      end

      def add_state_machine(*)
        raise_not_initialized_error
      end

      def stubba
        Central::Null.new(&method(:raise_not_initialized_error))
      end

      private

      def raise_not_initialized_error
        message = 'Mocha methods cannot be used outside the context of a test'
        raise NotInitializedError.new(message, caller)
      end
    end

    class << self
      def instance
        @instances.last || Null.build
      end

      def setup(assertion_counter)
        @instances ||= []
        mockery = new(assertion_counter)
        mockery.logger = instance.logger unless @instances.empty?
        @instances.push(mockery)
      end

      def verify
        instance.verify
      end

      def teardown(origin = nil)
        if @instances.nil?
          raise NotInitializedError, 'Mocha::Mockery.teardown called before Mocha::Mockery.setup'
        end

        instance.teardown(origin)
      ensure
        @instances.pop unless @instances.nil?
      end
    end

    def initialize(assertion_counter)
      @assertion_counter = assertion_counter
    end

    def named_mock(name)
      add_mock(Mock.new(self, @assertion_counter, Name.new(name)))
    end

    def unnamed_mock
      add_mock(Mock.new(self, @assertion_counter))
    end

    def mock_impersonating(object)
      add_mock(Mock.new(self, @assertion_counter, ImpersonatingName.new(object), ObjectReceiver.new(object)))
    end

    def mock_impersonating_any_instance_of(klass)
      add_mock(Mock.new(self, @assertion_counter, ImpersonatingAnyInstanceName.new(klass), AnyInstanceReceiver.new(klass)))
    end

    def new_state_machine(name)
      add_state_machine(StateMachine.new(name))
    end

    def verify
      unless mocks.all?(&:__verified__?)
        message = "not all expectations were satisfied\n#{mocha_inspect}"
        backtrace = if unsatisfied_expectations.empty?
                      caller
                    else
                      unsatisfied_expectations[0].backtrace
                    end
        raise ExpectationErrorFactory.build(message, backtrace)
      end
      expectations.reject(&:used?).each do |expectation|
        signature_proc = lambda { expectation.method_signature }
        check(:stubbing_method_unnecessarily, 'method unnecessarily', signature_proc, expectation.backtrace)
      end
    end

    def teardown(origin = nil)
      stubba.unstub_all
      mocks.each { |m| m.__expire__(origin) }
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

    def sequences
      @sequences ||= []
    end

    def mocha_inspect
      lines = []
      lines << "unsatisfied expectations:\n- #{unsatisfied_expectations.map(&:mocha_inspect).join("\n- ")}\n" if unsatisfied_expectations.any?
      lines << "satisfied expectations:\n- #{satisfied_expectations.map(&:mocha_inspect).join("\n- ")}\n" if satisfied_expectations.any?
      lines << "states:\n- #{state_machines.map(&:mocha_inspect).join("\n- ")}\n" if state_machines.any?
      lines.join
    end

    def on_stubbing(object, method)
      signature_proc = lambda { "#{object.mocha_inspect}.#{method}" }
      check(:stubbing_non_existent_method, 'non-existent method', signature_proc) do
        !(object.stubba_class.__method_exists__?(method) || object.stubba_respond_to?(method))
      end
      check(:stubbing_non_public_method, 'non-public method', signature_proc) do
        object.stubba_class.__method_exists__?(method, include_public_methods: false)
      end
      check(:stubbing_method_on_non_mock_object, 'method on non-mock object', signature_proc)
    end

    attr_writer :logger

    def logger
      @logger ||= Logger.new($stderr)
    end

    private

    def check(action, description, signature_proc, backtrace = caller)
      treatment = Mocha.configuration.send(action)
      return if (treatment == :allow) || (block_given? && !yield)

      method_signature = signature_proc.call
      message = "stubbing #{description}: #{method_signature}"
      raise StubbingError.new(message, backtrace) if treatment == :prevent

      logger.warn(message) if treatment == :warn
    end

    def expectations
      mocks.map { |mock| mock.__expectations__.to_a }.flatten
    end

    def unsatisfied_expectations
      expectations.reject(&:verified?)
    end

    def satisfied_expectations
      expectations.select(&:verified?)
    end

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
