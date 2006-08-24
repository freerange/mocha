require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/auto_verify'
require 'method_definer'

class AutoVerifyTest < Test::Unit::TestCase
  
  attr_reader :test_case
  
  def setup
    @test_case = Object.new
    class << test_case
      def self.add_teardown_method(symbol); end
      include AutoVerify
    end
  end
  
  def test_should_add_mock_type_expectations
    test_case.define_instance_accessor(:expectation_type, :expectations)
    test_case.define_instance_method(:build_mock_with_expectations) do |expectation_type, expectations|
      self.expectation_type = expectation_type
      self.expectations = expectations
    end
    expectations = { :method1 => :value1, :method2 => :value2 }
    
    test_case.mock(expectations)
    
    assert_equal :expects, test_case.expectation_type
    assert_equal expectations, test_case.expectations
  end
  
  def test_should_add_stub_type_expectations
    test_case.define_instance_accessor(:expectation_type, :expectations)
    test_case.define_instance_method(:build_mock_with_expectations) do |expectation_type, expectations|
      self.expectation_type = expectation_type
      self.expectations = expectations
    end
    expectations = { :method1 => :value1, :method2 => :value2 }
    
    test_case.stub(expectations)
    
    assert_equal :stubs, test_case.expectation_type
    assert_equal expectations, test_case.expectations
  end
  
  def test_should_build_mock
    mock = test_case.build_mock_with_expectations
    assert mock.is_a?(Mocha::Mock)
  end
  
  def test_should_build_new_mock_each_time
    assert_not_equal test_case.build_mock_with_expectations, test_case.build_mock_with_expectations
  end
  
  def test_should_store_each_new_mock
    expected = Array.new(3) { test_case.build_mock_with_expectations }
    assert_equal expected, test_case.mocks
  end
  
  def test_should_verify_each_mock_on_teardown
    mocks = Array.new(3) do
      mock = Object.new
      mock.define_instance_accessor(:verify_called)
      mock.define_instance_method(:verify) { self.verify_called = true }
      mock
    end
    test_case.replace_instance_method(:mocks)  { mocks }
    test_case.teardown_mocks
    assert mocks.all? { |mock| mock.verify_called }
  end
  
  def test_should_provide_block_for_adding_assertion
    mock_class = Class.new do
      def verify(&block); yield; end
    end
    mock = mock_class.new
    test_case.replace_instance_method(:mocks)  { [mock] }
    test_case.define_instance_accessor(:add_assertion_called)
    test_case.define_instance_method(:add_assertion) { self.add_assertion_called = true }
    test_case.teardown_mocks
    assert test_case.add_assertion_called
  end
  
  def test_should_reset_mocks_on_teardown
    mock = Class.new { define_method(:verify) {} }.new
    test_case.mocks << mock
    test_case.teardown_mocks
    assert test_case.mocks.empty?
  end
  
  def test_should_stub_everything
    mock = test_case.stub_everything
    assert_equal true, mock.stub_everything
  end
  
end