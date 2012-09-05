require 'mocha/deprecation'
require 'mocha/integration/test_unit'
require 'mocha/integration/mini_test'

module Mocha
  module Integration
    def self.activate
      if [Integration::TestUnit, Integration::MiniTest].map(&:activate).none?
        Deprecation.warning("Test::Unit or MiniTest must be loaded *before* Mocha.")
        Deprecation.warning("If you're integrating with another test library, you should probably require 'mocha_standalone' instead of 'mocha'")
      end
    end
  end
end
