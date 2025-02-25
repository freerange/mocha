# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

require 'mocha/invocation'
require 'mocha/exception_raiser'
require 'timeout'

class ExceptionRaiserTest < Mocha::TestCase
  include Mocha

  def new_invocation
    Invocation.new(:irrelevant, :irrelevant)
  end

  def test_should_raise_exception_with_specified_class_and_default_message
    exception_class = Class.new(StandardError)
    raiser = ExceptionRaiser.new(exception_class, nil)
    exception = assert_raises(exception_class) { raiser.evaluate(new_invocation) }
    assert_equal exception_class.to_s, exception.message
  end

  def test_should_raise_exception_with_specified_class_and_message
    exception_class = Class.new(StandardError)
    raiser = ExceptionRaiser.new(exception_class, 'message')
    exception = assert_raises(exception_class) { raiser.evaluate(new_invocation) }
    assert_equal 'message', exception.message
  end

  def test_should_raise_exception_instance
    exception_class = Class.new(StandardError)
    raiser = ExceptionRaiser.new(exception_class.new('message'), nil)
    exception = assert_raises(exception_class) { raiser.evaluate(new_invocation) }
    assert_equal 'message', exception.message
  end

  def test_should_raise_interrupt_exception_with_default_message_so_it_works_in_ruby_1_8_6
    raiser = ExceptionRaiser.new(Interrupt, nil)
    assert_raises(Interrupt) { raiser.evaluate(new_invocation) }
  end

  def test_should_raise_subclass_of_interrupt_exception_with_default_message_so_it_works_in_ruby_1_8_6
    exception_class = Class.new(Interrupt)
    raiser = ExceptionRaiser.new(exception_class, nil)
    assert_raises(exception_class) { raiser.evaluate(new_invocation) }
  end
end
