require 'mocha/options'

module Mocha

  module Integration

    class << self

      def monkey_patches
        patches = []
        if test_unit_testcase_defined? && !test_unit_testcase_inherits_from_miniunit_testcase?
          patches << 'mocha/integration/test_unit'
        end
        if mini_unit_testcase_defined?
          patches << 'mocha/integration/mini_test'
        end
        patches
      end

      def test_unit_testcase_defined?
        defined?(Test::Unit::TestCase)
      end

      def mini_unit_testcase_defined?
        defined?(MiniTest::Unit::TestCase)
      end

      def test_unit_testcase_inherits_from_miniunit_testcase?
        test_unit_testcase_defined? && mini_unit_testcase_defined? && Test::Unit::TestCase.ancestors.include?(MiniTest::Unit::TestCase)
      end

    end

  end

end

unless Mocha::Integration.monkey_patches.any? || $mocha_options["skip_integration"]
  raise "Test::Unit or MiniTest must be loaded *before* Mocha (use MOCHA_OPTIONS=skip_integration if you know what you are doing)."
end

Mocha::Integration.monkey_patches.each do |patch|
  require patch
end
