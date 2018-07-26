module Mocha
  # This class allows you to determine what should happen under certain circumstances. In each scenario, Mocha can be configured to {.allow do nothing}, {.warn_when display a warning message}, or {.prevent raise an exception}. The relevant scenario is identified using one of the following symbols:
  #
  # * +:stubbing_method_unnecessarily+ This is useful for identifying unused stubs. Unused stubs are often accidentally introduced when code is {http://martinfowler.com/bliki/DefinitionOfRefactoring.html refactored}. Allowed by default.
  # * +:stubbing_non_existent_method+ - This is useful if you want to ensure that methods you're mocking really exist. A common criticism of unit tests with mock objects is that such a test may (incorrectly) pass when an equivalent non-mocking test would (correctly) fail. While you should always have some integration tests, particularly for critical business functionality, this Mocha configuration setting should catch scenarios when mocked methods and real methods have become misaligned. Allowed by default.
  # * +:stubbing_non_public_method+ - Many people think that it's good practice only to mock public methods. This is one way to prevent your tests being too tightly coupled to the internal implementation of a class. Such tests tend to be very brittle and not much use when refactoring. Allowed by default.
  # * +:stubbing_method_on_non_mock_object+ - If you like the idea of {http://www.jmock.org/oopsla2004.pdf mocking roles not objects} and {http://www.mockobjects.com/2007/04/test-smell-mocking-concrete-classes.html you don't like stubbing concrete classes}, this is the setting for you. However, while this restriction makes a lot of sense in Java with its {http://java.sun.com/docs/books/tutorial/java/concepts/interface.html explicit interfaces}, it may be moot in Ruby where roles are probably best represented as Modules. Allowed by default.
  # * +:stubbing_method_on_nil+ - This is usually done accidentally, but there might be rare cases where it is intended. Prevented by default.
  #
  # @example Preventing unnecessary stubbing of a method
  #   Mocha::Configuration.prevent(:stubbing_method_unnecessarily)
  #
  #   example = mock('example')
  #   example.stubs(:unused_stub)
  #   # => Mocha::StubbingError: stubbing method unnecessarily:
  #   # =>   #<Mock:example>.unused_stub(any_parameters)
  #
  # @example Preventing stubbing of a method on a non-mock object
  #   Mocha::Configuration.prevent(:stubbing_method_on_non_mock_object)
  #
  #   class Example
  #     def example_method; end
  #   end
  #
  #   example = Example.new
  #   example.stubs(:example_method)
  #   # => Mocha::StubbingError: stubbing method on non-mock object:
  #   # =>   #<Example:0x593620>.example_method
  #
  # @example Preventing stubbing of a non-existent method
  #
  #   Mocha::Configuration.prevent(:stubbing_non_existent_method)
  #
  #   class Example
  #   end
  #
  #   example = Example.new
  #   example.stubs(:method_that_doesnt_exist)
  #   # => Mocha::StubbingError: stubbing non-existent method:
  #   # =>   #<Example:0x593760>.method_that_doesnt_exist
  #
  # @example Preventing stubbing of a non-public method
  #   Mocha::Configuration.prevent(:stubbing_non_public_method)
  #
  #   class Example
  #     def internal_method; end
  #     private :internal_method
  #   end
  #
  #   example = Example.new
  #   example.stubs(:internal_method)
  #   # => Mocha::StubbingError: stubbing non-public method:
  #   # =>   #<Example:0x593530>.internal_method
  #
  # Typically the configuration would be set globally in a +test_helper.rb+ or +spec_helper.rb+ file. However, it can also be temporarily overridden locally using the block syntax of the relevant method. In the latter case, the original configuration settings are restored when the block is exited.
  #
  # @example Temporarily allowing stubbing of a non-existent method
  #   Mocha::Configuration.prevent(:stubbing_non_public_method)
  #
  #   class Example
  #   end
  #
  #   Mocha::Configuration.allow(:stubbing_non_existent_method) do
  #     example = Example.new
  #     example.stubs(:method_that_doesnt_exist)
  #     # => no exception raised
  #   end
  class Configuration
    DEFAULTS = {
      :stubbing_method_unnecessarily => :allow,
      :stubbing_method_on_non_mock_object => :allow,
      :stubbing_non_existent_method => :allow,
      :stubbing_non_public_method => :allow,
      :stubbing_method_on_nil => :prevent
    }.freeze

    class << self
      # Allow the specified +action+.
      #
      # @param [Symbol] action one of +:stubbing_method_unnecessarily+, +:stubbing_method_on_non_mock_object+, +:stubbing_non_existent_method+, +:stubbing_non_public_method+, +:stubbing_method_on_nil+.
      # @yield optional block during which the configuration change will be changed before being returned to its original value at the end of the block.
      def allow(action, &block)
        change_config action, :allow, &block
      end

      # @private
      def allow?(action)
        configuration[action] == :allow
      end

      # Warn if the specified +action+ is attempted.
      #
      # @param [Symbol] action one of +:stubbing_method_unnecessarily+, +:stubbing_method_on_non_mock_object+, +:stubbing_non_existent_method+, +:stubbing_non_public_method+, +:stubbing_method_on_nil+.
      # @yield optional block during which the configuration change will be changed before being returned to its original value at the end of the block.
      def warn_when(action, &block)
        change_config action, :warn, &block
      end

      # @private
      def warn_when?(action)
        configuration[action] == :warn
      end

      # Raise a {StubbingError} if if the specified +action+ is attempted.
      #
      # @param [Symbol] action one of +:stubbing_method_unnecessarily+, +:stubbing_method_on_non_mock_object+, +:stubbing_non_existent_method+, +:stubbing_non_public_method+, +:stubbing_method_on_nil+.
      # @yield optional block during which the configuration change will be changed before being returned to its original value at the end of the block.
      def prevent(action, &block)
        change_config action, :prevent, &block
      end

      # @private
      def prevent?(action)
        configuration[action] == :prevent
      end

      # @private
      def reset_configuration
        @configuration = nil
      end

      private

      # @private
      def configuration
        @configuration ||= DEFAULTS.dup
      end

      # @private
      def change_config(action, new_value, &block)
        if block_given?
          temporarily_change_config action, new_value, &block
        else
          configuration[action] = new_value
        end
      end

      # @private
      def temporarily_change_config(action, new_value)
        original_value = configuration[action]
        configuration[action] = new_value
        yield
      ensure
        configuration[action] = original_value
      end
    end
  end
end
