require File.expand_path('../../test_helper', __FILE__)

require 'mocha/single_return_block'

class SingleReturnBlockTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_return_value
    value = SingleReturnBlock.new(Proc.new { |a,b| a+b })
    assert_equal 9, value.evaluate(4,5)
  end
  
end
