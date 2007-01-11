require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/auto_verify'
require 'method_definer'

class AutoVerifyTest < Test::Unit::TestCase
  
  attr_reader :test_case
  
  def setup
    @test_case = Object.new
    class << test_case
      def self.add_teardown_method(symbol); end
      include Mocha::AutoVerify
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
  
  def test_should_add_greedy_stub_type_expectations
    test_case.define_instance_accessor(:expectation_type, :expectations)
    test_case.define_instance_method(:build_mock_with_expectations) do |expectation_type, expectations|
      self.expectation_type = expectation_type
      self.expectations = expectations
    end
    expectations = { :method1 => :value1, :method2 => :value2 }
    
    test_case.stub_everything(expectations)
    
    assert_equal :stub_everything, test_case.expectation_type
    assert_equal expectations, test_case.expectations
  end
  
  def test_should_build_mock
    mock = test_case.build_mock_with_expectations
    assert mock.is_a?(Mocha::Mock)
  end
  
  def test_should_add_expectation_to_mock
    mock = test_case.build_mock_with_expectations(:expects, :expected_method => 'return_value')
    assert_equal 'return_value', mock.expected_method
  end
  
  def test_should_build_stub
    stub = test_case.build_mock_with_expectations(:stubs)
    assert stub.is_a?(Mocha::Mock)
  end
  
  def test_should_add_expectation_to_stub
    stub = test_case.build_mock_with_expectations(:stubs, :stubbed_method => 'return_value')
    assert_equal 'return_value', stub.stubbed_method
  end
  
  def test_should_build_greedy_stub
    greedy_stub = test_case.build_mock_with_expectations(:stub_everything)
    assert greedy_stub.stub_everything
  end
  
  def test_should_add_expectations_to_greedy_stub
    greedy_mock = test_case.build_mock_with_expectations(:stub_everything, :stubbed_method => 'return_value')
    assert_equal 'return_value', greedy_mock.stubbed_method
  end
  
  def test_should_build_new_mock_each_time
    assert_not_equal test_case.build_mock_with_expectations, test_case.build_mock_with_expectations
  end
  
  def test_should_store_each_new_mock
    expected = Array.new(3) { test_case.build_mock_with_expectations }
    assert_equal expected, test_case.mocks
  end
  
  def test_should_verify_each_mock
    mocks = Array.new(3) do
      mock = Object.new
      mock.define_instance_accessor(:verify_called)
      mock.define_instance_method(:verify) { self.verify_called = true }
      mock
    end
    test_case.replace_instance_method(:mocks)  { mocks }
    test_case.verify_mocks
    assert mocks.all? { |mock| mock.verify_called }
  end
  
  def test_should_yield_to_block_for_each_assertion
    mock_class = Class.new do
      def verify(&block); yield; end
    end
    mock = mock_class.new
    test_case.replace_instance_method(:mocks)  { [mock] }
    yielded = false
    test_case.verify_mocks { yielded = true }
    assert yielded
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
  
  def test_should_add_mock_to_mocks
    mock = test_case.mock
    assert_equal [mock], test_case.mocks
  end
  
  def test_should_add_stub_to_mocks
    stub = test_case.stub
    assert_equal [stub], test_case.mocks
  end
  
  def test_should_add_greedy_stub_to_mocks
    greedy_stub = test_case.stub_everything
    assert_equal [greedy_stub], test_case.mocks
  end
  
  def test_should_create_mock_with_name
    mock = test_case.mock('named_mock')
    assert_equal '#<Mock:named_mock>', mock.mocha_inspect
  end
  
  def test_should_create_stub_with_name
    stub = test_case.stub('named_stub')
    assert_equal '#<Mock:named_stub>', stub.mocha_inspect
  end
  
  def test_should_create_greedy_stub_with_name
    greedy_stub = test_case.stub_everything('named_greedy_stub')
    assert_equal '#<Mock:named_greedy_stub>', greedy_stub.mocha_inspect
  end
  
end