# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'mocha/inspect'

class ArrayInspectTest < Mocha::TestCase
  def test_should_return_string_representation_of_array
    array = [1, 2]
    assert_equal '[1, 2]', array.mocha_inspect
  end

  def test_should_return_unwrapped_array_when_wrapped_is_false
    array = [1, 2]
    assert_equal '1, 2', array.mocha_inspect(wrapped: false)
  end

  def test_should_use_mocha_inspect_on_each_item
    array = [1, 2, 'chris']
    assert_equal %([1, 2, "chris"]), array.mocha_inspect
  end
end
