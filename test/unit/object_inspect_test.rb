# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'mocha/inspect'
require 'mocha/ruby_version'
require 'mocha/ignoring_warning'
require 'method_definer'

class ObjectInspectTest < Mocha::TestCase
  include MethodDefiner
  include Mocha::IgnoringWarning

  def test_should_return_default_string_representation_of_object_not_including_instance_variables
    object = Object.new
    class << object
      attr_accessor :attribute
    end
    object.attribute = 'instance_variable'
    assert_match string_representation(id: object.__id__, klass: object.class), object.mocha_inspect
    assert_no_match(/instance_variable/, object.mocha_inspect)
  end

  def test_should_return_customized_string_representation_of_object
    object = Object.new
    class << object
      define_method(:inspect) { 'custom_inspect' }
    end
    assert_equal 'custom_inspect', object.mocha_inspect
  end

  def test_should_use_underscored_id_instead_of_object_id_or_id_so_that_they_can_be_stubbed
    object = Object.new

    ignoring_warning(/warning: redefining 'object_id' may cause serious problems/, if_: Mocha::RUBY_V34_PLUS) do
      replace_instance_method(object, :object_id) do
        flunk 'should not call `Object#object_id`'
      end
    end
    define_instance_method(object, :id) do
      flunk 'should not call `Object#id`'
    end

    assert_equal string_representation(id: object.__id__, klass: object.class), object.mocha_inspect
  end

  def test_should_not_call_object_instance_format_method
    object = Object.new
    class << object
      def format(*)
        'internal_format'
      end
    end
    assert_no_match(/internal_format/, object.mocha_inspect)
  end

  private

  def string_representation(id:, klass:)
    address = id * 2
    address += 0x100000000 if address < 0
    "#<#{klass}:0x#{Kernel.format('%<address>x', address: address)}>"
  end
end
