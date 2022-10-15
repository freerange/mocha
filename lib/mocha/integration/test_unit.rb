require 'mocha/debug'
require 'mocha/detection/test_unit'
require 'mocha/integration/test_unit/adapter'
require 'mocha/deprecation'

module Mocha
  module Integration
    module TestUnit
      def self.activate
        return false unless Detection::TestUnit.testcase
        test_unit_version = Gem::Version.new(Detection::TestUnit.version)

        Debug.puts "Detected Test::Unit version: #{test_unit_version}"

        unless TestUnit::Adapter.applicable_to?(test_unit_version)
          raise 'Versions of test-unit earlier than v2.5.1 are not supported.'
        end

        unless ::Test::Unit::TestCase < TestUnit::Adapter
          Debug.puts "Applying #{TestUnit::Adapter.description}"
          ::Test::Unit::TestCase.send(:include, TestUnit::Adapter)
        end

        true
      end
    end
  end
end
