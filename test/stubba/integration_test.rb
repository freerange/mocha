require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'stubba/object'
require 'stubba/test_case'

class IntegrationTest < Test::Unit::TestCase
  
  class DontMessWithMe
    def self.method_x
      :original_return_value
    end
  end

  def test_should_stub_class_method_within_test
    test_class = Class.new(Test::Unit::TestCase) do
      def test_me
        DontMessWithMe.expects(:method_x).returns(:new_return_value)
        assert_equal :new_return_value, DontMessWithMe.method_x
      end
    end
    test = test_class.new(:test_me)

    replace_stubba(nil) do
      test_result = Test::Unit::TestResult.new
      test.run(test_result) {}
      assert test_result.passed?
    end
  end

  def test_should_leave_stubbed_class_unchanged_after_test
    test_class = Class.new(Test::Unit::TestCase) do
      def test_me
        DontMessWithMe.expects(:method_x).returns(:new_return_value)
      end
    end
    test = test_class.new(:test_me)

    replace_stubba(nil) do
      test.run(Test::Unit::TestResult.new) {}
      assert_equal :original_return_value, DontMessWithMe.method_x
    end
  end
  
  def test_should_reset_expectations_after_test
    test_class = Class.new(Test::Unit::TestCase) do
      def test_me
        DontMessWithMe.expects(:method_x)
      end
    end
    test = test_class.new(:test_me)
    
    replace_stubba(nil) do
      test.run(Test::Unit::TestResult.new) {}
    end
    assert_equal 0, DontMessWithMe.mocha.expectations.size
  end  

end