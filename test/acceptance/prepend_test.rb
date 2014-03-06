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

  def test_stubbing_a_prepended_method
    mod = Module.new do
      def my_method
        super + " World"
      end
    end
    instance = Class.new do
      prepend mod
      def my_method
        "Hello"
      end
    end
    test_result = run_as_test do
      instance.any_instance.stubs(:my_method).returns("Bye World")
      object = instance.new
      assert_equal "Bye World", object.my_method
    end
    assert_passed(test_result)

    object = instance.new
    assert_equal "Hello World", object.my_method
  end
end
