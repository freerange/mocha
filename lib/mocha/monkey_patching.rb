require 'mocha/options'
require 'mocha/deprecation'

module Mocha

  module MonkeyPatching

    class << self

      def monkey_patches
        patches = []
        if test_unit_testcase_defined? && !test_unit_testcase_inherits_from_miniunit_testcase?
          patches << 'mocha/monkey_patching/test_unit'
        end
        if mini_test_testcase_defined?
          patches << 'mocha/monkey_patching/mini_test'
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

  def self.const_missing(symbol)
    if symbol == :Integration
      Mocha::Deprecation.warning("Mocha::Integration is an internal module and will soon be removed/re-purposed. Please do not use it.")
      return MonkeyPatching
    end
    super
  end

end

unless Mocha::MonkeyPatching.monkey_patches.any?
  Mocha::Deprecation.warning("Test::Unit or MiniTest must be loaded *before* Mocha.")
  Mocha::Deprecation.warning("If you're integrating with another test library, you should probably require 'mocha_standalone' instead of 'mocha'")
end

Mocha::MonkeyPatching.monkey_patches.each do |patch|
  require patch
end
