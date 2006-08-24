require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/mock'

require 'stubba/setup_and_teardown'

class SetupAndTeardownTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_add_setup_stubs_to_setup_methods
    test_case_class = Class.new do
      class << self
        attr_accessor :symbol
        define_method(:add_setup_method) { |symbol| @symbol = symbol }
        define_method(:add_teardown_method) {}
      end
      include SetupAndTeardown
    end
    
    assert_equal :setup_stubs, test_case_class.symbol
  end
  
  def test_should_add_teardown_stubs_to_teardown_methods
    test_case_class = Class.new do
      class << self
        attr_accessor :symbol
        define_method(:add_setup_method) {}
        define_method(:add_teardown_method) { |symbol| @symbol = symbol }
      end
      include SetupAndTeardown
    end
    
    assert_equal :teardown_stubs, test_case_class.symbol
  end
  
  def test_should_instantiate_new_stubba
    test_case = stubbed_test_case_class.new
    test_case.setup_stubs
    
    assert $stubba
    assert $stubba.is_a?(Stubba::Central)
  end

  def test_should_verify_all_expectations
    test_case = stubbed_test_case_class.new
    stubba = Mock.new
    stubba.expects(:verify_all)
    stubba.stubs(:unstub_all)
    $stubba = stubba
    
    test_case.teardown_stubs
    
    stubba.verify
  end

  def test_should_pass_block_to_add_assertion_to_test_case
    test_case = stubbed_test_case_class.new
    $stubba = Mock.new
    $stubba.stubs(:verify_all).yields
    $stubba.stubs(:unstub_all)
    
    test_case.teardown_stubs
    
    assert_equal true, test_case.add_assertion_called 
  end

  def test_should_unstub_all_stubbed_methods
    test_case = stubbed_test_case_class.new
    stubba = Mock.new
    stubba.stubs(:verify_all)
    stubba.expects(:unstub_all)
    $stubba = stubba
    
    test_case.teardown_stubs
    
    stubba.verify
  end

  def test_should_unstub_all_stubbed_methods_even_if_verify_all_raises_exception
    test_case = stubbed_test_case_class.new
    stubba = Mock.new
    stubba.stubs(:verify_all).raises(Exception)
    stubba.expects(:unstub_all)
    $stubba = stubba
    
    assert_raises(Exception) { test_case.teardown_stubs }
    
    stubba.verify
  end

  def test_should_set_stubba_to_nil
    test_case = stubbed_test_case_class.new
    $stubba = Mock.new
    $stubba.stubs(:verify_all)
    $stubba.stubs(:unstub_all)

    test_case.teardown_stubs
    
    assert_nil $stubba
  end
  
  def test_should_set_stubba_to_nil_even_if_verify_all_raises_exception
    test_case = stubbed_test_case_class.new
    $stubba = Mock.new
    $stubba.stubs(:verify_all).raises(Exception)
    $stubba.stubs(:unstub_all)

    assert_raises(Exception) { test_case.teardown_stubs }
    
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
      class << self
        define_method(:add_setup_method) {}
        define_method(:add_teardown_method) {}
      end
      attr_accessor :add_assertion_called
      define_method(:add_assertion) { self.add_assertion_called = true }
      include SetupAndTeardown
    end
  end

end

