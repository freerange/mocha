require File.expand_path('../../test_helper', __FILE__)
require 'mocha/object_methods'

class ModuleMethodsTest < Mocha::TestCase
  def setup
    @module = Module.new.extend(Mocha::ObjectMethods)
  end

  def test_should_use_stubba_module_method_for_module
    stubbed_method = @module.build_stubbed_method(:foo)
    assert_equal @module, stubbed_method.instance_variable_get(:@mock_owner)
    assert_equal @module.singleton_class, stubbed_method.instance_variable_get(:@original_method_owner)
  end

  def test_should_stub_self_for_module
    assert_equal @module, @module.build_stubbed_method(:foo).stubbee
  end
end
