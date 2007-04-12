require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'mocha/single_return_value'

class SingleReturnValueTest < Test::Unit::TestCase
  
  include Mocha

  def test_should_return_value
    value = SingleReturnValue.new('value')
    assert_equal 'value', value.evaluate
  end
  
  def test_should_return_result_of_calling_proc
    proc = lambda { 'value' }
    value = SingleReturnValue.new(proc)
    assert_equal 'value', value.evaluate
  end
  
end
