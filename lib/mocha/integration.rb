require 'mocha/deprecation'

module Mocha
  module Integration
  end
end

integration_files = []
if defined?(Test::Unit::TestCase) && !(defined?(MiniTest::Unit::TestCase) && (Test::Unit::TestCase < MiniTest::Unit::TestCase))
  integration_files << 'mocha/integration/test_unit'
end
if defined?(MiniTest::Unit::TestCase)
  integration_files << 'mocha/integration/mini_test'
end

if integration_files.any?
  integration_files.each do |integration_file|
    require integration_file
  end
else
  Mocha::Deprecation.warning("Test::Unit or MiniTest must be loaded *before* Mocha.")
  Mocha::Deprecation.warning("If you're integrating with another test library, you should probably require 'mocha_standalone' instead of 'mocha'")
end
