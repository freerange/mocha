require 'mocha_standalone'
require 'mocha/expectation_error'
require 'minitest/unit'

mini_test_version = begin
  Gem::Version.new(MiniTest::Unit::VERSION)
rescue LoadError
  Gem::Version.new('0.0.0')
end

unless Gem::Requirement.new('>= 3.3.0').satisfied_by?(mini_test_version)
  raise "Mocha::Adapters::MiniTest requires MiniTest version 3.3.0 or higher."
end

module Mocha
  module Adapters
    module MiniTest

      class AssertionCounter
        def initialize(test_case)
          @test_case = test_case
        end

        def increment
          @test_case.assert(true)
        end
      end

      include Mocha::API

      def self.included(mod)
        Mocha::ExpectationErrorFactory.exception_class = ::MiniTest::Assertion
      end

      def before_setup
        mocha_setup
        super
      end

      def before_teardown
        return unless passed?
        assertion_counter = AssertionCounter.new(self)
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

