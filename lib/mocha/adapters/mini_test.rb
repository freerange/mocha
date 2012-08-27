require 'mocha_standalone'
require 'mocha/integration/assertion_counter'
require 'mocha/expectation_error'

module Mocha
  module Adapters
    module MiniTest
      include Mocha::API

      def self.applicable_to?(mini_test_version)
        Gem::Requirement.new('>= 3.3.0').satisfied_by?(mini_test_version)
      end

      def self.description
        "adapter for MiniTest gem >= v3.3.0"
      end

      def self.included(mod)
        Mocha::ExpectationErrorFactory.exception_class = ::MiniTest::Assertion
      end

      def before_setup
        mocha_setup
        super
      end

      def before_teardown
        return unless passed?
        assertion_counter = Integration::AssertionCounter.new(self)
        mocha_verify(assertion_counter)
      ensure
        super
      end

      def after_teardown
        super
        mocha_teardown
      end
    end
  end
end

