require 'mocha/deprecation'
require 'mocha/integration/test_unit'
require 'mocha/integration/mini_test'

module Mocha
  module Integration
    def self.activate
      integration_modules = []
      if defined?(::Test::Unit::TestCase) && !(defined?(::MiniTest::Unit::TestCase) && (::Test::Unit::TestCase < ::MiniTest::Unit::TestCase))
        integration_modules << Integration::TestUnit
      end
      if defined?(::MiniTest::Unit::TestCase)
        integration_modules << Integration::MiniTest
      end
      if integration_modules.any?
        integration_modules.each do |integration_module|
          integration_module.activate
        end
      else
        Deprecation.warning("Test::Unit or MiniTest must be loaded *before* Mocha.")
        Deprecation.warning("If you're integrating with another test library, you should probably require 'mocha_standalone' instead of 'mocha'")
      end
    end
  end
end
