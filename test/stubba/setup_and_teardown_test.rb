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
  
  private
  
  def stubbed_test_case_class
    Class.new do
      class << self
        define_method(:add_setup_method) {}
        define_method(:add_teardown_method) {}
      end
      include SetupAndTeardown
    end
  end

end

