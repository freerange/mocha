require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

class PrependTest < Mocha::TestCase

  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  if RUBY_VERSION >= '2.0'

    module Mod1
      def my_method
        super + " World"
      end
    end

    module Mod2
      def my_method
        super + " Wide"
      end
    end

    def test_stubbing_a_prepended_method
      klass = Class.new do
        prepend Mod1

        def my_method
          "Hello"
        end
      end

      assert_basic_stubbing_works_on(klass)
      assert_equal "Hello World", klass.new.my_method
    end

    def test_stubbing_multiple_prepended_method
      klass = Class.new do
        prepend Mod1
        prepend Mod2

        def my_method
          "Hello"
        end
      end

      assert_basic_stubbing_works_on(klass)
      assert_equal "Hello World Wide", klass.new.my_method
    end

    def assert_basic_stubbing_works_on(klass)
      assert_snapshot_unchanged(klass) do
        test_result = run_as_test do
          klass.any_instance.stubs(:my_method).returns("Bye World")
          assert_equal "Bye World", klass.new.my_method
        end
        assert_passed(test_result)
      end
    end

  end
end
