require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'smart_test_case/multiple_setup_and_teardown'
require 'active_record_test_case'

class MultipleSetupAndTeardownTest < Test::Unit::TestCase
  
  def test_1
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      add_setup_method(:setup_1)
      define_method(:setup_1) { methods_called << :setup_1 }
      define_method(:test_me) { methods_called << :test_me }
    end
    test = test_case.new(:test_me)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:setup_1, :test_me], test.methods_called
  end
  
  def test_2
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      define_method(:setup) { methods_called << :setup }
      include MultipleSetupAndTeardown
      add_setup_method(:setup_1)
      define_method(:setup_1) { methods_called << :setup_1 }
      define_method(:test_me) { methods_called << :test_me }
    end
    test = test_case.new(:test_me)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:setup, :setup_1, :test_me], test.methods_called
  end
  
  def test_3
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      define_method(:setup) { methods_called << :setup }
      add_setup_method(:setup_1)
      define_method(:setup_1) { methods_called << :setup_1 }
      define_method(:test_me) { methods_called << :test_me }
    end
    test = test_case.new(:test_me)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:setup_1, :setup, :test_me], test.methods_called
  end
  
  def test_4
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      add_setup_method(:setup_1)
      define_method(:setup_1) { methods_called << :setup_1 }
    end
    derived_test_case = Class.new(test_case) do
      define_method(:setup) { methods_called << :setup }
      define_method(:test_me) { methods_called << :test_me }
    end
    test = derived_test_case.new(:test_me)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:setup_1, :setup, :test_me], test.methods_called
  end
  
  def test_5
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include ActiveRecordTestCase
      include MultipleSetupAndTeardown
      add_setup_method(:setup_1)
      define_method(:setup_1) { methods_called << :setup_1 }
    end
    derived_test_case = Class.new(test_case) do
      define_method(:setup) { methods_called << :setup }
      define_method(:test_me) { methods_called << :test_me }
    end
    test = derived_test_case.new(:test_me)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:setup_with_fixtures, :setup_1, :setup, :test_me, :teardown_with_fixtures], test.methods_called
  end
  
end