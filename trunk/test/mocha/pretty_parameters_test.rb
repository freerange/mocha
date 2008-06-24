require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/pretty_parameters'

class PrettyParametersTest < Test::Unit::TestCase
  
  include Mocha

  def test_should_remove_outer_array_braces
    params = [1, 2, [3, 4]]
    parameters = PrettyParameters.new(params)
    assert_equal '1, 2, [3, 4]', parameters.pretty
  end
  
  def test_should_display_numeric_arguments_as_is
    params = [1, 2, 3]
    parameters = PrettyParameters.new(params)
    assert_equal '1, 2, 3', parameters.pretty
  end
  
  def test_should_remove_curly_braces_if_hash_is_only_argument
    params = [{:a => 1, :z => 2}]
    parameters = PrettyParameters.new(params)
    assert_match /^:[az] => [12], :[az] => [12]$/, parameters.pretty
  end
  
  def test_should_not_remove_curly_braces_if_hash_is_not_the_only_argument
    params = [1, {:a => 1}]
    parameters = PrettyParameters.new(params)
    assert_equal '1, {:a => 1}', parameters.pretty
  end

end