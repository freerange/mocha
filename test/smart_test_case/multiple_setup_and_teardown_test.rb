require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'smart_test_case/multiple_setup_and_teardown'
require 'active_record_test_case'

class MultipleSetupAndTeardownTest < Test::Unit::TestCase
  
  def test_should_call_added_setup
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      add_setup_method(:added_setup)
      define_method(:added_setup) { methods_called << :added_setup }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:added_setup, :test_method], test.methods_called
  end
  
  def test_should_call_added_teardown
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      add_teardown_method(:added_teardown)
      define_method(:added_teardown) { methods_called << :added_teardown }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:test_method, :added_teardown], test.methods_called
  end
  
  def test_should_call_both_added_teardowns_even_if_one_raises_exception
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      add_teardown_method(:added_teardown_1)
      add_teardown_method(:added_teardown_2)
      define_method(:added_teardown_1) { methods_called << :added_teardown_1 }
      define_method(:added_teardown_2) { methods_called << :added_teardown_2; raise }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert_equal false, test_result.passed?
    assert_equal [:test_method, :added_teardown_2, :added_teardown_1], test.methods_called
  end
  
  def test_should_call_added_setup_and_setup_defined_before_module_included
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      define_method(:setup) { methods_called << :setup }
      include MultipleSetupAndTeardown
      add_setup_method(:added_setup)
      define_method(:added_setup) { methods_called << :added_setup }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:setup, :added_setup, :test_method], test.methods_called
  end
  
  def test_should_call_added_teardown_and_teardown_defined_before_module_included
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      define_method(:teardown) { methods_called << :teardown }
      include MultipleSetupAndTeardown
      add_teardown_method(:added_teardown)
      define_method(:added_teardown) { methods_called << :added_teardown }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:test_method, :added_teardown, :teardown], test.methods_called
  end
  
  def test_should_call_added_setup_and_setup_defined_after_module_included
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      define_method(:setup) { methods_called << :setup }
      add_setup_method(:added_setup)
      define_method(:added_setup) { methods_called << :added_setup }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:added_setup, :setup, :test_method], test.methods_called
  end
  
  def test_should_call_added_teardown_and_teardown_defined_after_module_included
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      define_method(:teardown) { methods_called << :teardown }
      add_teardown_method(:added_teardown)
      define_method(:added_teardown) { methods_called << :added_teardown }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:test_method, :teardown, :added_teardown], test.methods_called
  end
  
  def test_should_call_added_setup_and_setup_defined_in_derived_test_case
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      add_setup_method(:added_setup)
      define_method(:added_setup) { methods_called << :added_setup }
    end
    derived_test_case = Class.new(test_case) do
      define_method(:setup) { methods_called << :setup }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = derived_test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:added_setup, :setup, :test_method], test.methods_called
  end
  
  def test_should_call_added_teardown_and_teardown_defined_in_derived_test_case
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include MultipleSetupAndTeardown
      add_teardown_method(:added_teardown)
      define_method(:added_teardown) { methods_called << :added_teardown }
    end
    derived_test_case = Class.new(test_case) do
      define_method(:teardown) { methods_called << :teardown }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = derived_test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:test_method, :teardown, :added_teardown], test.methods_called
  end
  
  def test_should_call_added_setup_and_setup_defined_in_derived_test_case_with_active_record_setup_with_fixtures
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include ActiveRecordTestCase
      include MultipleSetupAndTeardown
      add_setup_method(:added_setup)
      define_method(:added_setup) { methods_called << :added_setup }
    end
    derived_test_case = Class.new(test_case) do
      define_method(:setup) { methods_called << :setup }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = derived_test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:setup_with_fixtures, :added_setup, :setup, :test_method, :teardown_with_fixtures], test.methods_called
  end
    
  def test_should_call_added_teardown_and_teardown_defined_in_derived_test_case_with_active_record_teardown_with_fixtures
    test_case = Class.new(Test::Unit::TestCase) do
      define_method(:methods_called) { @methods_called ||= [] }
      include ActiveRecordTestCase
      include MultipleSetupAndTeardown
      add_teardown_method(:added_teardown)
      define_method(:added_teardown) { methods_called << :added_teardown }
    end
    derived_test_case = Class.new(test_case) do
      define_method(:teardown) { methods_called << :teardown }
      define_method(:test_method) { methods_called << :test_method }
    end
    test = derived_test_case.new(:test_method)
    test_result = Test::Unit::TestResult.new
    test.run(test_result) {}
    assert test_result.passed?
    assert_equal [:setup_with_fixtures, :test_method, :teardown, :added_teardown, :teardown_with_fixtures], test.methods_called
  end
    
end