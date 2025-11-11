require 'deprecation_disabler'
require 'mocha/deprecation'

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
end
