require File.expand_path('../../test_helper', __FILE__)

require 'mocha/single_return_value'

class SingleReturnValueTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_return_value
    value = SingleReturnValue.new('value')
    assert_equal 'value', value.evaluate
  end
  
  def test_should_return_value_ignore_arguments
    value = SingleReturnValue.new('value')
    assert_equal 'value', value.evaluate(4,5)
  end
  
end
