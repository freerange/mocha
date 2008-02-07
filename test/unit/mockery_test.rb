require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/mockery'

class MockeryTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_build_instance_of_mockery
    mockery = Mockery.instance
    assert_not_nil mockery
    assert_kind_of Mockery, mockery
  end
  
  def test_should_cache_instance_of_mockery
    mockery_1 = Mockery.instance
    mockery_2 = Mockery.instance
    assert_same mockery_1, mockery_2
  end
  
  def test_should_expire_mockery_instance_cache
    mockery_1 = Mockery.instance
    Mockery.reset_instance
    mockery_2 = Mockery.instance
    assert_not_same mockery_1, mockery_2
  end
  
  def test_should_raise_expectation_error_because_not_all_expectations_are_satisfied
    mockery = Mockery.new
    mock_1 = mockery.named_mock('mock-1') { expects(:method_1) }
    mock_2 = mockery.named_mock('mock-2') { expects(:method_2) }
    1.times { mock_1.method_1 }
    0.times { mock_2.method_2 }
    assert_raises(ExpectationError) { mockery.verify }
  end
  
  def test_should_reset_list_of_mocks_on_teardown
    mockery = Mockery.new
    mock = mockery.unnamed_mock { expects(:my_method) }
    mockery.teardown
    assert_nothing_raised(ExpectationError) { mockery.verify }
  end
  
  def test_should_build_instance_of_stubba_on_instantiation
    mockery = Mockery.new
    assert_not_nil mockery.stubba
    assert_kind_of Central, mockery.stubba
  end
  
  def test_should_build_new_instance_of_stubba_on_teardown
    mockery = Mockery.new
    stubba_1 = mockery.stubba
    mockery.teardown
    stubba_2 = mockery.stubba
    assert_not_same stubba_1, stubba_2
  end
  
  class FakeMethod
    def stub; end
    def unstub; end
  end
  
  def test_should_unstub_all_methods_on_teardown
    mockery = Mockery.new
    stubba = mockery.stubba
    stubba.stub(FakeMethod.new)
    mockery.teardown
    assert stubba.stubba_methods.empty?
  end
  
end