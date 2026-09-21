# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

require 'mocha/invocation'
require 'mocha/executes_return_value'

class ExecutesReturnValueTest < Mocha::TestCase
  def test_should_record_returned_value
    invocation = Mocha::Invocation.new(:irrelevant, :foo, [21])
    value = Mocha::ExecutesReturnValue.new(lambda { |argument| argument * 2 })

    assert_equal 42, value.evaluate(invocation)
    assert_equal '# => 42', invocation.result_description
  end

  def test_should_record_and_reraise_exception
    invocation = Mocha::Invocation.new(:irrelevant, :foo)
    error = Exception.new('boom')
    value = Mocha::ExecutesReturnValue.new(lambda { raise error })

    assert_same error, assert_raises(Exception) { value.evaluate(invocation) }
    assert_equal '# => raised boom', invocation.result_description
  end
end
