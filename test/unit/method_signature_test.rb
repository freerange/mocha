require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/method_signature'
require 'method_definer'

class MethodSignatureTest < Test::Unit::TestCase
  
  include Mocha

  def test_should_match_if_actual_method_name_is_same_as_expected_method_name
    method_signature = MethodSignature.new(mock = nil, :method_name)
    assert method_signature.match?(:method_name)
  end

  def test_should_not_match_if_actual_method_name_is_not_same_as_expected_method_name
    method_signature = MethodSignature.new(mock = nil, :method_name)
    assert !method_signature.match?(:different_method_name)
  end
  
  def test_should_match_any_actual_parameters_if_no_expected_parameters_specified
    method_signature = MethodSignature.new(mock = nil, :method_name)
    assert method_signature.match?(:method_name, actual_parameters = [1, 2, 3])
  end

  def test_should_match_if_actual_parameters_are_same_as_expected_parameters
    method_signature = MethodSignature.new(mock = nil, :method_name, expected_parameters = [4, 5, 6])
    assert method_signature.match?(:method_name, actual_parameters = [4, 5, 6])
  end
  
  def test_should_not_match_if_actual_parameters_are_different_from_expected_parameters
    method_signature = MethodSignature.new(mock = nil, :method_name, expected_parameters = [4, 5, 6])
    assert !method_signature.match?(:method_name, actual_parameters = [1, 2, 3])
  end
  
  def test_should_not_match_if_there_are_less_actual_parameters_than_expected_parameters
    method_signature = MethodSignature.new(mock = nil, :method_name, expected_parameters = [4, 5, 6])
    assert !method_signature.match?(:method_name, actual_parameters = [4, 5])
  end
  
  def test_should_not_match_if_there_are_more_actual_parameters_than_expected_parameters
    method_signature = MethodSignature.new(mock = nil, :method_name, expected_parameters = [4, 5])
    assert !method_signature.match?(:method_name, actual_parameters = [4, 5, 6])
  end
  
  def test_should_match_if_actual_parameters_satisfy_matching_block
    method_signature = MethodSignature.new(mock = nil, :method_name) { |x, y| x + y == 3 }
    assert method_signature.match?(:method_name, actual_parameters = [1, 2])
  end

  def test_should_not_match_if_actual_parameters_do_not_satisfy_matching_block
    method_signature = MethodSignature.new(mock = nil, :method_name) { |x, y| x + y == 3 }
    assert !method_signature.match?(:method_name, actual_parameters = [2, 3])
  end
  
  def test_should_match_if_actual_parameters_are_same_as_modified_expected_parameters
    method_signature = MethodSignature.new(mock = nil, :method_name, expected_parameters = [1, 2])
    method_signature.modify(expected_parameters = [2, 3])
    assert method_signature.match?(:method_name, actual_parameters = [2, 3])
  end

  def test_should_match_if_actual_parameters_satisfy_modified_matching_block
    method_signature = MethodSignature.new(mock = nil, :method_name) { |x, y| x + y == 3 }
    method_signature.modify(expected_parameters = nil) { |x, y| x + y == 5 }
    assert method_signature.match?(:method_name, actual_parameters = [2, 3])
  end
  
  def test_should_return_similar_method_signatures
    similar_expectation_1 = Object.new
    similar_expectation_1.define_instance_method(:method_signature) { 'similar_expectation_1' }
    similar_expectation_2 = Object.new
    similar_expectation_2.define_instance_method(:method_signature) { 'similar_expectation_2' }
    similar_expectations = [similar_expectation_1, similar_expectation_2]
    mock = Object.new
    mock.define_instance_accessor :requested_method_name
    mock.define_instance_method(:similar_expectations) { |method_name| self.requested_method_name = method_name; similar_expectations }
    
    method_signature = MethodSignature.new(mock, :method_name)
    
    assert_equal ['similar_expectation_1', 'similar_expectation_2'], method_signature.similar_method_signatures
    assert_equal :method_name, mock.requested_method_name
  end

  def test_should_remove_outer_array_braces
    params = [1, 2, [3, 4]]
    method_signature = MethodSignature.new(nil, nil, params)
    assert_equal '(1, 2, [3, 4])', method_signature.parameter_signature
  end
  
  def test_should_display_numeric_arguments_as_is
    params = [1, 2, 3]
    method_signature = MethodSignature.new(nil, nil, params)
    assert_equal '(1, 2, 3)', method_signature.parameter_signature
  end
  
  def test_should_remove_curly_braces_if_hash_is_only_argument
    params = [{:a => 1, :z => 2}]
    method_signature = MethodSignature.new(nil, nil, params)
    assert_nil method_signature.parameter_signature.index('{')
    assert_nil method_signature.parameter_signature.index('}')
  end
  
  def test_should_not_remove_curly_braces_if_hash_is_not_the_only_argument
    params = [1, {:a => 1}]
    method_signature = MethodSignature.new(nil, nil, params)
    assert_equal '(1, {:a => 1})', method_signature.parameter_signature
  end
  
end