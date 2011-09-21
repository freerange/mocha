require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/json_equivalent'
require 'mocha/inspect'

class JsonEquivalentTest < Test::Unit::TestCase

  include Mocha::ParameterMatchers

  def test_should_match_parameter_matching_json_representation_of_object
    matcher = json_equivalent({"foo" => "bar"})
    assert matcher.matches?(["{\"foo\":\"bar\"}"])
  end

  def test_should_not_match_parameter_not_matching_json_representation_of_object
    matcher = json_equivalent({"foo" => "bar"})
    assert !matcher.matches?(["{\"foo\":\"BAD\"}"])
  end

  def test_should_describe_matcher
    matcher = json_equivalent({"foo" => "bar"})
    assert_equal "json_equivalent({'foo' => 'bar'})", matcher.mocha_inspect
  end

end
