# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/responds_with'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'

class RespondsWithTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_parameter_responding_with_expected_value
    matcher = responds_with(:upcase, 'FOO')
    assert matcher.matches?(['foo'])
  end

  def test_should_not_match_parameter_responding_with_unexpected_value
    matcher = responds_with(:upcase, 'FOO')
    assert !matcher.matches?(['bar'])
  end

  def test_should_match_parameter_responding_with_nested_responds_with_matcher
    matcher = responds_with(:foo, responds_with(:bar, 'baz'))
    object = Class.new do
      def foo
        Class.new do
          def bar
            'baz'
          end
        end.new
      end
    end.new
    assert matcher.matches?([object])
  end

  def test_should_describe_matcher
    matcher = responds_with(:foo, :bar)
    assert_equal 'responds_with(:foo, :bar)', matcher.mocha_inspect
  end

  def test_should_match_parameter_responding_with_expected_values_for_given_messages
    matcher = responds_with(upcase: 'FOO', reverse: 'oof')
    assert matcher.matches?(['foo'])
  end

  def test_should_describe_matcher_with_multiple_messages_vs_results
    matcher = responds_with(foo: :bar, baz: 123)
    assert_equal 'all_of(responds_with(:foo, :bar), responds_with(:baz, 123))', matcher.mocha_inspect
  end
end
