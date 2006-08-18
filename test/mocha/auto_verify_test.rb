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
  
  def test_should_build_mock
    assert test_case.mock.is_a?(Mocha::Mock)
  end
  
  def test_should_build_new_mock_each_time
    assert_not_equal test_case.mock, test_case.mock
  end
  
  def test_should_store_each_new_mock
    expected = Array.new(3) { test_case.mock }
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
  
end