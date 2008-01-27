require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/mock'
require 'mocha/setup_and_teardown'

class SetupAndTeardownTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_instantiate_new_stubba
    test_case = stubbed_test_case_class.new
    test_case.setup_stubs
    
    assert $stubba
    assert $stubba.is_a?(Mocha::Central)
  end

  def test_should_verify_all_expectations
    test_case = stubbed_test_case_class.new
    stubba = Mock.new
    stubba.expects(:verify_all).with(:assertion_counter)
    $stubba = stubba
    
    test_case.verify_stubs(:assertion_counter)
    
    stubba.verify
  end

  def test_should_unstub_all_stubbed_methods
    test_case = stubbed_test_case_class.new
    stubba = Mock.new
    stubba.expects(:unstub_all)
    $stubba = stubba
    
    test_case.teardown_stubs
    
    stubba.verify
  end

  def test_should_set_stubba_to_nil
    test_case = stubbed_test_case_class.new
    $stubba = Mock.new
    $stubba.stubs(:unstub_all)

    test_case.teardown_stubs
    
    assert_nil $stubba
  end
  
  def test_should_not_raise_exception_if_no_stubba_central_available
    test_case = stubbed_test_case_class.new
    $stubba = nil
    assert_nothing_raised { test_case.teardown_stubs }
  end
  
  private
  
  def stubbed_test_case_class
    Class.new do
      include Mocha::SetupAndTeardown
    end
  end

end

