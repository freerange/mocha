require 'mocha/ruby_version'
require 'mocha/central'
require 'mocha/mock'
require 'mocha/names'
require 'mocha/receivers'
require 'mocha/state_machine'
require 'mocha/logger'
require 'mocha/configuration'
require 'mocha/stubbing_error'
require 'mocha/not_initialized_error'
require 'mocha/expectation_error_factory'

module Mocha
  class Mockery
    class Null < self
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
        instances.last || Null.new
      end

      def setup
        mockery = new
        mockery.logger = instance.logger unless instances.empty?
        @instances.push(mockery)
      end

      def verify(*args)
        instance.verify(*args)
      end

      def teardown
        instance.teardown
      ensure
        @instances.pop
        @instances = nil if instances.empty?
      end

      private

      def instances
        @instances ||= []
      end
    end

    def named_mock(name, &block)
      add_mock(Mock.new(self, Name.new(name), &block))
    end

    def unnamed_mock(&block)
      add_mock(Mock.new(self, &block))
    end

    def mock_impersonating(object, &block)
      add_mock(Mock.new(self, ImpersonatingName.new(object), ObjectReceiver.new(object), &block))
    end

    def mock_impersonating_any_instance_of(klass, &block)
      add_mock(Mock.new(self, ImpersonatingAnyInstanceName.new(klass), AnyInstanceReceiver.new(klass), &block))
    end

    def new_state_machine(name)
      add_state_machine(StateMachine.new(name))
    end

    def verify(assertion_counter = nil)
      unless mocks.all? { |mock| mock.__verified__?(assertion_counter) }
        message = "not all expectations were satisfied\n#{mocha_inspect}"
        backtrace = if unsatisfied_expectations.empty?
                      caller
                    else
                      unsatisfied_expectations[0].backtrace
                    end
        raise ExpectationErrorFactory.build(message, backtrace)
      end
      expectations.each do |e|
        unless Mocha::Configuration.allow?(:stubbing_method_unnecessarily)
          next if e.used?
          on_stubbing_method_unnecessarily(e)
        end
      end
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

    def mocha_inspect
      message = ''
      message << "unsatisfied expectations:\n- #{unsatisfied_expectations.map(&:mocha_inspect).join("\n- ")}\n" unless unsatisfied_expectations.empty?
      message << "satisfied expectations:\n- #{satisfied_expectations.map(&:mocha_inspect).join("\n- ")}\n" unless satisfied_expectations.empty?
      message << "states:\n- #{state_machines.map(&:mocha_inspect).join("\n- ")}" unless state_machines.empty?
      message
    end

    def on_stubbing(object, method)
      method = PRE_RUBY_V19 ? method.to_s : method.to_sym
      unless Mocha::Configuration.allow?(:stubbing_non_existent_method)
        unless method_exists_or_responds_to?(method, object)
          on_stubbing_non_existent_method(object, method)
        end
      end
      unless Mocha::Configuration.allow?(:stubbing_non_public_method)
        if object.method_exists?(method, false)
          on_stubbing_non_public_method(object, method)
        end
      end
      unless Mocha::Configuration.allow?(:stubbing_method_on_nil)
        if object.nil?
          on_stubbing_method_on_nil(object, method)
        end
      end
      return if Mocha::Configuration.allow?(:stubbing_method_on_non_mock_object)
      on_stubbing_method_on_non_mock_object(object, method)
    end

    def on_stubbing_non_existent_method(object, method)
      if Mocha::Configuration.prevent?(:stubbing_non_existent_method)
        raise StubbingError.new("stubbing non-existent method: #{object.mocha_inspect}.#{method}", caller)
      end
      return unless Mocha::Configuration.warn_when?(:stubbing_non_existent_method)
      logger.warn "stubbing non-existent method: #{object.mocha_inspect}.#{method}"
    end

    def on_stubbing_non_public_method(object, method)
      if Mocha::Configuration.prevent?(:stubbing_non_public_method)
        raise StubbingError.new("stubbing non-public method: #{object.mocha_inspect}.#{method}", caller)
      end
      return unless Mocha::Configuration.warn_when?(:stubbing_non_public_method)
      logger.warn "stubbing non-public method: #{object.mocha_inspect}.#{method}"
    end

    def on_stubbing_method_on_nil(object, method)
      if Mocha::Configuration.prevent?(:stubbing_method_on_nil)
        raise StubbingError.new("stubbing method on nil: #{object.mocha_inspect}.#{method}", caller)
      end
      return unless Mocha::Configuration.warn_when?(:stubbing_method_on_nil)
      logger.warn "stubbing method on nil: #{object.mocha_inspect}.#{method}"
    end

    def on_stubbing_method_on_non_mock_object(object, method)
      if Mocha::Configuration.prevent?(:stubbing_method_on_non_mock_object)
        raise StubbingError.new("stubbing method on non-mock object: #{object.mocha_inspect}.#{method}", caller)
      end
      return unless Mocha::Configuration.warn_when?(:stubbing_method_on_non_mock_object)
      logger.warn "stubbing method on non-mock object: #{object.mocha_inspect}.#{method}"
    end

    def on_stubbing_method_unnecessarily(expectation)
      if Mocha::Configuration.prevent?(:stubbing_method_unnecessarily)
        raise StubbingError.new("stubbing method unnecessarily: #{expectation.method_signature}", expectation.backtrace)
      end
      return unless Mocha::Configuration.warn_when?(:stubbing_method_unnecessarily)
      logger.warn "stubbing method unnecessarily: #{expectation.method_signature}"
    end

    attr_writer :logger

    def logger
      @logger ||= Logger.new($stderr)
    end

    private

    def method_exists_or_responds_to?(method, object)
      object.method_exists?(method, true) || object.respond_to?(method.to_sym)
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
