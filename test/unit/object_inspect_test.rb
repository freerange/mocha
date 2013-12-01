require File.expand_path('../../test_helper', __FILE__)
require 'mocha/inspect'
require 'method_definer'
require 'mocha/object_methods'
require 'mocha/expectation_error_factory'

class ObjectInspectTest < Mocha::TestCase

  def test_should_return_default_string_representation_of_object_not_including_instance_variables
    object = Object.new
    class << object
      attr_accessor :attribute
    end
    object.attribute = 'instance_variable'
    assert_match Regexp.new("^#<Object:0x[0-9A-Fa-f]{1,8}.*>$"), object.mocha_inspect
    assert_no_match(/instance_variable/, object.mocha_inspect)
  end

  def test_should_return_default_string_representation_of_object_when_stack_error_caused_by_mocks_in_inspect
    object = Object.new.extend(Mocha::ObjectMethods)
    object.expects(:inspect).once.returns('custom inspect')
    assert_equal 'custom inspect', object.inspect
    error = assert_raise(Mocha::ExpectationErrorFactory.exception_class) do
      object.mocha_inspect
    end
    assert_match Regexp.new("#<Object:0x[0-9A-Fa-f]{1,8}.*>"), error.message
  end

  def test_should_return_customized_string_representation_of_object
    object = Object.new
    class << object
      define_method(:inspect) { 'custom_inspect' }
    end
    assert_equal 'custom_inspect', object.mocha_inspect
  end

  def test_should_use_underscored_id_instead_of_object_id_or_id_so_that_they_can_be_stubbed
    calls = []
    object = Object.new
    object.replace_instance_method(:id) { calls << :id; return 1 } if RUBY_VERSION < '1.9'
    object.replace_instance_method(:object_id) { calls << :object_id; return 1 }
    object.replace_instance_method(:__id__) { calls << :__id__; return 1 }

    object.mocha_inspect

    assert_equal [:__id__], calls.uniq
  end

end
