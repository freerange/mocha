require 'mocha/debug'
require 'mocha/detection/mini_test'
require 'mocha/integration/mini_test/adapter'

module Mocha
  module Integration
    module Minitest
      def self.activate
        target = Detection::Minitest.testcase
        return false unless target

        mini_test_version = Gem::Version.new(Detection::Minitest.version)
        Debug.puts "Detected Minitest version: #{mini_test_version}"

        unless Minitest::Adapter.applicable_to?(mini_test_version)
          raise 'Versions of minitest earlier than v3.3.0 are not supported.'
        end

        unless target < Minitest::Adapter
          Debug.puts "Applying #{Minitest::Adapter.description}"
          target.send(:include, Minitest::Adapter)
        end

        true
      end
    end
  end
end
