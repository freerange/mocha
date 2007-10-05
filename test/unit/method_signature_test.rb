require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/method_signature'

class MethodSignatureTest < Test::Unit::TestCase
  
  include Mocha

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