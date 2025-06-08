# frozen_string_literal: true

require 'mocha/detection/minitest'
require 'mocha/integration/minitest/adapter'

module Mocha
  module Integration
    module Minitest
      def self.activate # rubocop:disable Naming/PredicateMethod
        target = Detection::Minitest.testcase
        return false unless target

        minitest_version = Gem::Version.new(Detection::Minitest.version)
        warn "Detected Minitest version: #{minitest_version}" if $DEBUG

        unless Minitest::Adapter.applicable_to?(minitest_version)
          raise 'Versions of minitest earlier than v3.3.0 are not supported.'
        end

        unless target < Minitest::Adapter
          warn "Applying #{Minitest::Adapter.description}" if $DEBUG
          target.send(:include, Minitest::Adapter)
        end

        true
      end
    end
  end
end
