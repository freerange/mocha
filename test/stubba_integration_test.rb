require 'test_helper'

require 'stubba/object'
require 'smart_test_case/multiple_setup_and_teardown'
require 'stubba/setup_and_teardown'

class StubbaIntegrationTest < Test::Unit::TestCase
  
  class DontMessWithMe
    def self.method_x
      :original_return_value
    end
  end
  
  def test_should_stub_class_method_within_test
    test_class = Class.new(Test::Unit::TestCase) do
      include MultipleSetupAndTeardown
      include SetupAndTeardown
      define_method(:test_me) do
        DontMessWithMe.expects(:method_x).returns(:new_return_value)
        assert_equal :new_return_value, DontMessWithMe.method_x
      end
    end
    test = test_class.new(:test_me)

    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
  end

  def test_should_leave_stubbed_class_unchanged_after_test
    test_class = Class.new(Test::Unit::TestCase) do
      include MultipleSetupAndTeardown
      include SetupAndTeardown
      define_method(:test_me) do
        DontMessWithMe.expects(:method_x).returns(:new_return_value)
      end
    end
    test = test_class.new(:test_me)

    test.run(Test::Unit::TestResult.new) {}
    assert_equal :original_return_value, DontMessWithMe.method_x
  end
  
  def test_should_reset_expectations_after_test
    test_class = Class.new(Test::Unit::TestCase) do
      include MultipleSetupAndTeardown
      include SetupAndTeardown
      define_method(:test_me) do
        DontMessWithMe.expects(:method_x)
      end
    end
    test = test_class.new(:test_me)
    
    test.run(Test::Unit::TestResult.new) {}
    assert_equal 0, DontMessWithMe.mocha.expectations.size
  end  

end