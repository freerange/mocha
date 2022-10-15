require 'mocha/debug'
require 'mocha/detection/mini_test'
require 'mocha/integration/mini_test/adapter'

module Mocha
  module Integration
    module MiniTest
      def self.activate
        target = Detection::MiniTest.testcase
        return false unless target

        mini_test_version = Gem::Version.new(Detection::MiniTest.version)
        Debug.puts "Detected MiniTest version: #{mini_test_version}"

        unless MiniTest::Adapter.applicable_to?(mini_test_version)
          raise 'Versions of minitest earlier than v3.3.0 are not supported.'
        end

        unless target < MiniTest::Adapter
          Debug.puts "Applying #{MiniTest::Adapter.description}"
          target.send(:include, MiniTest::Adapter)
        end

        true
      end
    end
  end
end
