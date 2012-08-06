require 'mocha/options'
require 'mocha/deprecation'

module Mocha

  module Integration

    class << self

      def monkey_patches
        patches = []
        if test_unit_testcase_defined? && !test_unit_testcase_inherits_from_miniunit_testcase?
          patches << 'mocha/integration/test_unit'
        end
        if mini_test_testcase_defined?
          patches << 'mocha/integration/mini_test'
        end
        patches
      end

      def test_unit_testcase_defined?
        defined?(Test::Unit::TestCase)
      end

      def mini_test_testcase_defined?
        defined?(MiniTest::Unit::TestCase)
      end

      def test_unit_testcase_inherits_from_miniunit_testcase?
        test_unit_testcase_defined? && mini_test_testcase_defined? && Test::Unit::TestCase.ancestors.include?(MiniTest::Unit::TestCase)
      end

    end

  end

end

unless Mocha::Integration.monkey_patches.any?
  Mocha::Deprecation.warning("Test::Unit or MiniTest must be loaded *before* Mocha.")
  Mocha::Deprecation.warning("If you're integrating with another test library, you should probably require 'mocha_standalone' instead of 'mocha'")
end

Mocha::Integration.monkey_patches.each do |patch|
  require patch
end
