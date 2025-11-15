require 'deprecation_disabler'
require 'mocha/deprecation'
require 'mocha/parameter_matchers/deprecations'

module ParameterMatchersTestHelper
  module SetupMethods
    def setup
      super
      Mocha::Deprecation.messages = []
    end
  end

  def self.deprecation_tests_for_matcher_method(method_name, *args)
    Module.new do
      def self.included(base)
        base.prepend SetupMethods
      end

      define_method :test_should_deprecate_method_defined_in_outer_namespace do
        object = Class.new do
          include Mocha::ParameterMatchers
        end.new
        DeprecationDisabler.disable_deprecations do
          object.public_send(method_name, *args)
        end
        assert_includes(
          Mocha::Deprecation.messages,
          "Calling Mocha::ParameterMatchers##{method_name} is deprecated. Use Mocha::ParameterMatchers::Methods##{method_name} instead."
        )
      end

      define_method :test_should_allow_method_defined_in_inner_namespace do
        DeprecationDisabler.disable_deprecations do
          public_send(method_name, *args)
        end
        refute_includes(
          Mocha::Deprecation.messages,
          "Calling Mocha::ParameterMatchers##{method_name} is deprecated. Use Mocha::ParameterMatchers::Methods##{method_name} instead."
        )
      end
    end
  end

  def self.deprecation_tests_for_matcher_class(class_name)
    Module.new do
      def self.included(base)
        base.prepend SetupMethods
        base.extend Mocha::ParameterMatchers::Deprecations
      end

      define_method :test_should_deprecate_referencing_matcher_class_from_test_class do
        DeprecationDisabler.disable_deprecations do
          self.class.const_get(class_name)
        end
        assert_includes(
          Mocha::Deprecation.messages,
          "Referencing #{class_name} outside its namespace is deprecated. Use fully-qualified Mocha::ParameterMatchers::#{class_name} instead."
        )
      end

      define_method :test_should_allow_referencing_fully_qualified_matcher_class_from_test_class do
        DeprecationDisabler.disable_deprecations do
          self.class.const_get("Mocha::ParameterMatchers::#{class_name}")
        end
        refute_includes(
          Mocha::Deprecation.messages,
          "Referencing #{class_name} outside its namespace is deprecated. Use fully-qualified Mocha::ParameterMatchers::#{class_name} instead."
        )
      end
    end
  end
end
