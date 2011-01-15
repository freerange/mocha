require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha'

class GithubIssue20Test < Test::Unit::TestCase

  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  class MyClass
    def my_instance_method
      :original_value
    end
    # class << self
    #   attr_accessor :my_instance
    # end
  end

  def test_me
    # MyClass.my_instance = MyClass.new
    test_case = Class.new(Test::Unit::TestCase) do
      def setup
        @my_instance = MyClass.new
      end
      def test_1
        @my_instance.stubs(:my_instance_method).returns(:first_value)
        assert_equal :first_value, @my_instance.my_instance_method
      end
      def test_2
        assert_equal :original_value, @my_instance.my_instance_method
        MyClass.any_instance.stubs(:my_instance_method).returns(:second_value)
        assert_equal :second_value, @my_instance.my_instance_method
      end
    end
    test_result = run_test_case(test_case)
    assert_passed(test_result)
  end

end
