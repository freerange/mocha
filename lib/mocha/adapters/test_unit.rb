require 'mocha_standalone'
require 'mocha/expectation_error'
require 'test/unit/assertionfailederror'

test_unit_version = begin
  load 'test/unit/version.rb'
  Gem::Version.new(Test::Unit::VERSION)
rescue LoadError
  Gem::Version.new('1.x')
end

unless Gem::Requirement.new('>= 2.5.1').satisfied_by?(test_unit_version)
  raise "Mocha::Adapters::TestUnit requires Test::Unit version 2.5.1 or higher."
end

module Mocha
  module Adapters
    module TestUnit

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
        Mocha::ExpectationErrorFactory.exception_class = Test::Unit::AssertionFailedError

        mod.setup :mocha_setup

        mod.cleanup do
          assertion_counter = AssertionCounter.new(self)
          mocha_verify(assertion_counter)
        end

        mod.teardown :mocha_teardown, after: :append
      end
    end
  end
end

