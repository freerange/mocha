require File.expand_path('../../test_helper', __FILE__)
require 'mocha/mock'
require 'mocha/singleton_class'

require 'mocha/instance_method'

class InstanceMethodTest < Mocha::TestCase
  include Mocha

  if RUBY_V2_PLUS
    def test_should_reuse_existing_prepended_module_when_stubbing_multiple_existing_methods
      klass = Class.new do
        def self.method_x; end

        def self.method_y; end
      end

      [:method_x, :method_y].each do |method_name|
        method = InstanceMethod.new(klass, method_name)
        method.hide_original_method
      end
      assert_equal 1, klass.singleton_class.ancestors.grep(InstanceMethod::PrependedModule).size
    end
  else
    def test_should_hide_original_method
      klass = Class.new { def self.method_x; end }
      klass.singleton_class.send(:alias_method, :_method, :method)
      method = InstanceMethod.new(klass, :method_x)

      method.hide_original_method

      assert_equal false, klass.respond_to?(:method_x)
    end
  end

  def test_should_not_raise_error_hiding_method_that_isnt_defined
    klass = Class.new
    method = InstanceMethod.new(klass, :method_x)

    assert_nothing_raised { method.hide_original_method }
  end

  def test_should_not_raise_error_hiding_method_in_class_that_implements_method_called_method
    klass = Class.new { def self.method; end }
    method = InstanceMethod.new(klass, :method)

    assert_nothing_raised { method.hide_original_method }
  end

  def test_should_define_a_new_method_which_should_call_mocha_method_missing
    klass = Class.new { def self.method_x; end }
    mocha = build_mock
    klass.define_instance_method(:mocha) { mocha }
    mocha.expects(:method_x).with(:param1, :param2).returns(:result)
    method = InstanceMethod.new(klass, :method_x)

    method.hide_original_method
    method.define_new_method
    result = klass.method_x(:param1, :param2)

    assert_equal :result, result
    assert mocha.__verified__?
  end

  def test_should_include_the_filename_and_line_number_in_exceptions
    klass = Class.new { def self.method_x; end }
    mocha = build_mock
    klass.define_instance_method(:mocha) { mocha }
    mocha.stubs(:method_x).raises(Exception)
    method = InstanceMethod.new(klass, :method_x)

    method.hide_original_method
    method.define_new_method

    expected_filename = 'stubbed_method.rb'
    expected_line_number = 61

    exception = assert_raises(Exception) { klass.method_x }
    matching_line = exception.backtrace.find do |line|
      filename, line_number, _context = line.split(':')
      filename.include?(expected_filename) && line_number.to_i == expected_line_number
    end

    assert_not_nil matching_line, "Expected to find #{expected_filename}:#{expected_line_number} in the backtrace:\n #{exception.backtrace.join("\n")}"
  end

  def test_should_remove_new_method
    klass = Class.new { def self.method_x; end }
    method = InstanceMethod.new(klass, :method_x)

    method.remove_new_method

    assert_equal false, klass.respond_to?(:method_x)
  end

  def test_should_restore_original_method
    klass = Class.new do
      def self.method_x
        :original_result
      end
    end
    klass.singleton_class.send(:alias_method, :_method, :method)
    method = InstanceMethod.new(klass, :method_x)

    method.hide_original_method
    method.define_new_method
    method.remove_new_method
    method.restore_original_method

    assert klass.respond_to?(:method_x)
    assert_equal :original_result, klass.method_x
  end

  def test_should_restore_original_method_accepting_a_block_parameter
    klass = Class.new do
      def self.method_x(&block)
        block.call if block_given?
      end
    end
    klass.singleton_class.send(:alias_method, :_method, :method)
    method = InstanceMethod.new(klass, :method_x)

    method.hide_original_method
    method.define_new_method
    method.remove_new_method
    method.restore_original_method

    block_called = false
    klass.method_x { block_called = true }
    assert block_called
  end

  def test_should_not_restore_original_method_if_none_was_defined_in_first_place
    klass = Class.new do
      def self.method_x
        :new_result
      end
    end
    method = InstanceMethod.new(klass, :method_x)

    method.restore_original_method

    assert_equal :new_result, klass.method_x
  end

  def test_should_call_hide_original_method
    klass = Class.new { def self.method_x; end }
    method = InstanceMethod.new(klass, :method_x)
    method.hide_original_method
    method.define_instance_accessor(:hide_called)
    method.replace_instance_method(:hide_original_method) { self.hide_called = true }

    method.stub

    assert method.hide_called
  end

  def test_should_call_define_new_method
    klass = Class.new { def self.method_x; end }
    method = InstanceMethod.new(klass, :method_x)
    method.define_instance_accessor(:define_called)
    method.replace_instance_method(:define_new_method) { self.define_called = true }

    method.stub

    assert method.define_called
  end

  def test_should_call_remove_new_method
    klass = Class.new { def self.method_x; end }
    method = InstanceMethod.new(klass, :method_x)
    mocha = build_mock
    klass.define_instance_method(:mocha) { mocha }
    method.replace_instance_method(:reset_mocha) {}
    method.define_instance_accessor(:remove_called)
    method.replace_instance_method(:remove_new_method) { self.remove_called = true }

    method.unstub

    assert method.remove_called
  end

  def test_should_call_restore_original_method
    klass = Class.new { def self.method_x; end }
    mocha = build_mock
    klass.define_instance_method(:mocha) { mocha }
    method = InstanceMethod.new(klass, :method_x)
    method.replace_instance_method(:reset_mocha) {}
    method.define_instance_accessor(:restore_called)
    method.replace_instance_method(:restore_original_method) { self.restore_called = true }

    method.unstub

    assert method.restore_called
  end

  def test_should_call_mocha_unstub
    klass = Class.new { def self.method_x; end }
    method = InstanceMethod.new(klass, :method_x)
    method.replace_instance_method(:restore_original_method) {}
    mocha = Class.new do
      class << self
        attr_accessor :unstub_method
      end
      def self.unstub(method)
        self.unstub_method = method
      end
    end
    mocha.define_instance_method(:any_expectations?) { true }
    method.replace_instance_method(:mock) { mocha }

    method.unstub
    assert_equal mocha.unstub_method, :method_x
  end

  def test_should_call_stubbee_reset_mocha_if_no_expectations_remaining
    klass = Class.new { def self.method_x; end }
    method = InstanceMethod.new(klass, :method_x)
    method.replace_instance_method(:remove_new_method) {}
    method.replace_instance_method(:restore_original_method) {}
    mocha = Class.new
    mocha.define_instance_method(:unstub) { |method_name| }
    mocha.define_instance_method(:any_expectations?) { false }
    method.replace_instance_method(:mock) { mocha }
    stubbee = Class.new do
      attr_accessor :reset_mocha_called
      def reset_mocha
        self.reset_mocha_called = true
      end
    end.new
    method.replace_instance_method(:stubbee) { stubbee }

    method.unstub

    assert stubbee.reset_mocha_called
  end

  def test_should_return_mock_for_stubbee
    mocha = Object.new
    stubbee = Object.new
    stubbee.define_instance_method(:mocha) { mocha }
    method = InstanceMethod.new(stubbee, :method_name)
    assert_equal mocha, method.mock
  end

  def test_should_not_match_if_other_object_has_a_different_class
    method = InstanceMethod.new(Object.new, :method)
    other_object = Object.new
    assert !method.matches?(other_object)
  end

  def test_should_not_match_if_other_instance_method_has_different_stubbee
    stubbee1 = Object.new
    stubbee2 = Object.new
    method1 = InstanceMethod.new(stubbee1, :method)
    method2 = InstanceMethod.new(stubbee2, :method)
    assert !method1.matches?(method2)
  end

  def test_should_not_match_if_other_instance_method_has_different_method
    stubbee = Object.new
    method1 = InstanceMethod.new(stubbee, :method_1)
    method2 = InstanceMethod.new(stubbee, :method_2)
    assert !method1.matches?(method2)
  end

  def test_should_match_if_other_instance_method_has_same_stubbee_and_same_method_so_no_attempt_is_made_to_stub_a_method_twice
    stubbee = Object.new
    method1 = InstanceMethod.new(stubbee, :method)
    method2 = InstanceMethod.new(stubbee, :method)
    assert method1.matches?(method2)
  end

  def test_should_match_if_other_instance_method_has_same_stubbee_and_same_method_but_stubbee_equal_method_lies_like_active_record_association_proxy
    stubbee = Class.new do
      def equal?(_other)
        false
      end
    end.new
    method1 = InstanceMethod.new(stubbee, :method)
    method2 = InstanceMethod.new(stubbee, :method)
    assert method1.matches?(method2)
  end

  private

  def build_mock
    Mock.new(nil)
  end
end
