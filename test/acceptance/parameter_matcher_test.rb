require File.expand_path('../acceptance_test_helper', __FILE__)

class ParameterMatcherTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_match_hash_parameter_which_is_exactly_the_same
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key_1: 'value_1')
      mock.method(key_1: 'value_1')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_hash_parameter_which_is_not_exactly_the_same
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key_1: 'value_1')
      mock.method(key_1: 'value_1', key_2: 'value_2')
    end
    assert_failed(test_result)
  end

  def test_should_not_match_hash_parameter_when_method_invoked_with_no_parameters
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key_1: 'value_1')
      mock.method
    end
    assert_failed(test_result)
  end

  def test_should_match_hash_parameter_with_specified_key
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:key_1))
      mock.method(key_1: 'value_1', key_2: 'value_2')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_hash_parameter_with_specified_key
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:key_1))
      mock.method(key_2: 'value_2')
    end
    assert_failed(test_result)
  end

  def test_should_match_hash_parameter_with_specified_value
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_value('value_1'))
      mock.method(key_1: 'value_1', key_2: 'value_2')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_hash_parameter_with_specified_value
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_value('value_1'))
      mock.method(key_2: 'value_2')
    end
    assert_failed(test_result)
  end

  def test_should_match_hash_parameter_with_specified_key_value_pair
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entry(:key_1, 'value_1'))
      mock.method(key_1: 'value_1', key_2: 'value_2')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_hash_parameter_with_specified_key_value_pair
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entry(:key_1, 'value_2'))
      mock.method(key_1: 'value_1', key_2: 'value_2')
    end
    assert_failed(test_result)
  end

  def test_should_match_hash_parameter_with_specified_hash_entry
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entry(key_1: 'value_1'))
      mock.method(key_1: 'value_1', key_2: 'value_2')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_hash_parameter_with_specified_hash_entry
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entry(key_1: 'value_2'))
      mock.method(key_1: 'value_1', key_2: 'value_2')
    end
    assert_failed(test_result)
  end

  def test_should_match_hash_parameter_with_specified_entries
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entries(key_1: 'value_1', key_2: 'value_2'))
      mock.method(key_1: 'value_1', key_2: 'value_2', key_3: 'value_3')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_hash_parameter_with_specified_entries
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entries(key_1: 'value_1', key_2: 'value_2'))
      mock.method(key_1: 'value_1', key_2: 'value_3')
    end
    assert_failed(test_result)
  end

  def test_should_match_parameter_that_matches_regular_expression
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(regexp_matches(/meter/))
      mock.method('this parameter should match')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameter_that_does_not_match_regular_expression
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(regexp_matches(/something different/))
      mock.method('this parameter should not match')
    end
    assert_failed(test_result)
  end

  def test_should_match_hash_parameter_with_specified_entries_using_nested_matchers
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entries(:key_1 => regexp_matches(/value_1/), kind_of(Symbol) => 'value_2'))
      mock.method(key_1: 'value_1', key_2: 'value_2', key_3: 'value_3')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_hash_parameter_with_specified_entries_using_nested_matchers
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entries(:key_1 => regexp_matches(/value_1/), kind_of(String) => 'value_2'))
      mock.method(key_1: 'value_2', key_2: 'value_3')
    end
    assert_failed(test_result)
  end

  def test_should_match_hash_parameter_that_is_exactly_a_key_that_is_a_string_with_a_value_that_is_an_integer
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(is_a(String) => is_a(Integer))
      mock.method('key_1' => 123)
    end
    assert_passed(test_result)
  end

  def test_should_not_match_hash_parameter_that_is_exactly_a_key_that_is_a_string_with_a_value_that_is_an_integer_because_value_not_integer
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(is_a(String) => is_a(Integer))
      mock.method('key_1' => '123')
    end
    assert_failed(test_result)
  end

  def test_should_not_match_hash_parameter_that_is_exactly_a_key_that_is_a_string_with_a_value_that_is_an_integer_because_of_extra_entry
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(is_a(String) => is_a(Integer))
      mock.method('key_1' => 123, 'key_2' => 'doesntmatter')
    end
    assert_failed(test_result)
  end

  def test_should_match_parameter_that_matches_any_value
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(any_of('value_1', 'value_2')).times(2)
      mock.method('value_1')
      mock.method('value_2')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameter_that_does_not_match_any_value
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(any_of('value_1', 'value_2'))
      mock.method('value_3')
    end
    assert_failed(test_result)
  end

  def test_should_match_parameter_that_matches_any_of_the_given_matchers
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:foo) | has_key(:bar)).times(2)
      mock.method(foo: 'fooval')
      mock.method(bar: 'barval')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameter_that_does_not_match_any_of_the_given_matchers
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:foo) | has_key(:bar))
      mock.method(baz: 'bazval')
    end
    assert_failed(test_result)
  end

  def test_should_match_parameter_that_matches_all_values
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(all_of('value_1', 'value_1'))
      mock.method('value_1')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameter_that_does_not_match_all_values
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(all_of('value_1', 'value_2'))
      mock.method('value_1')
    end
    assert_failed(test_result)
  end

  def test_should_match_parameter_that_matches_all_matchers
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:foo) & has_key(:bar))
      mock.method(foo: 'fooval', bar: 'barval')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameter_that_does_not_match_all_matchers
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:foo) & has_key(:bar))
      mock.method(foo: 'fooval', baz: 'bazval')
    end
    assert_failed(test_result)
  end

  def test_should_match_parameter_that_responds_with_specified_value
    klass = Class.new do
      def quack
        'quack'
      end
    end
    duck = klass.new
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(responds_with(:quack, 'quack'))
      mock.method(duck)
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameter_that_does_not_respond_with_specified_value
    klass = Class.new do
      def quack
        'woof'
      end
    end
    duck = klass.new
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(responds_with(:quack, 'quack'))
      mock.method(duck)
    end
    assert_failed(test_result)
  end

  def test_should_match_parameter_that_is_equivalent_uri
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(equivalent_uri('http://example.com/foo?b=2&a=1'))
      mock.method('http://example.com/foo?a=1&b=2')
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameter_that_is_not_equivalent
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(equivalent_uri('http://example.com/foo?a=1'))
      mock.method('http://example.com/foo?a=1&b=2')
    end
    assert_failed(test_result)
  end

  def test_should_match_parameter_when_value_is_divisible_by_four
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with { |actual_value| (actual_value % 4).zero? }
      mock.method(8)
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameter_when_value_is_not_divisible_by_four
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with { |actual_value| (actual_value % 4).zero? }
      mock.method(9)
    end
    assert_failed(test_result)
  end

  def test_should_match_parameters_when_values_add_up_to_ten
    test_result = run_as_test do
      mock = mock()
      matcher = lambda { |*values| values.inject(0) { |sum, n| sum + n } == 10 }
      mock.expects(:method).with(&matcher)
      mock.method(1, 2, 3, 4)
    end
    assert_passed(test_result)
  end

  def test_should_not_match_parameters_when_values_do_not_add_up_to_ten
    test_result = run_as_test do
      mock = mock()
      matcher = lambda { |*values| values.inject(0) { |sum, n| sum + n } == 10 }
      mock.expects(:method).with(&matcher)
      mock.method(1, 2, 3, 4, 5)
    end
    assert_failed(test_result)
  end
end
