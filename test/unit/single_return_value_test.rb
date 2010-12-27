require File.expand_path('../../test_helper', __FILE__)

require 'mocha/single_return_value'

class SingleReturnValueTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_return_value
    value = SingleReturnValue.new('value')
    assert_equal 'value', value.evaluate
  end

  def test_should_evaluate_block
    klass = Class.new do
      def single_block(&block)
        SingleReturnValue.new(block)
      end
    end
    value = klass.new.single_block { 'value from block' }
    assert_equal 'value from block', value.evaluate
  end

  def test_should_evaluate_proc
    value = SingleReturnValue.new(proc { "value from proc" })
    assert_equal 'value from proc', value.evaluate
  end

end
