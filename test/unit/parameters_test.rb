require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/parameters'

class ParametersTest < Test::Unit::TestCase
  
  include Mocha

  def test_should_remove_outer_array_braces
    params = [1, 2, [3, 4]]
    parameters = Parameters.new(params)
    assert_equal '(1, 2, [3, 4])', parameters.to_s
  end
  
  def test_should_display_numeric_arguments_as_is
    params = [1, 2, 3]
    parameters = Parameters.new(params)
    assert_equal '(1, 2, 3)', parameters.to_s
  end
  
  def test_should_remove_curly_braces_if_hash_is_only_argument
    params = [{:a => 1, :z => 2}]
    parameters = Parameters.new(params)
    assert_nil parameters.to_s.index('{')
    assert_nil parameters.to_s.index('}')
  end
  
  def test_should_not_remove_curly_braces_if_hash_is_not_the_only_argument
    params = [1, {:a => 1}]
    parameters = Parameters.new(params)
    assert_equal '(1, {:a => 1})', parameters.to_s
  end

end