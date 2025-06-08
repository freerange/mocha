# frozen_string_literal: true

require 'mocha/detection/test_unit'
require 'mocha/integration/test_unit/adapter'

module Mocha
  module Integration
    module TestUnit
      def self.activate # rubocop:disable Naming/PredicateMethod
        target = Detection::TestUnit.testcase
        return false unless target

        test_unit_version = Gem::Version.new(Detection::TestUnit.version)
        warn "Detected Test::Unit version: #{test_unit_version}" if $DEBUG

        unless TestUnit::Adapter.applicable_to?(test_unit_version)
          raise 'Versions of test-unit earlier than v2.5.1 are not supported.'
        end

        unless target < TestUnit::Adapter
          warn "Applying #{TestUnit::Adapter.description}" if $DEBUG
          target.send(:include, TestUnit::Adapter)
        end

        true
      end
    end
  end
end
