require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/matches_fn'
require 'mocha/inspect'

class MatchesFnTest < Mocha::TestCase

  include Mocha::ParameterMatchers

  def test_should_match_when_fn_returns_true
    matcher = matches_fn(Proc.new { |arg| arg == 99 })
    assert matcher.matches?([99])
  end

  def test_should_not_match_when_fn_returns_false
    matcher = matches_fn(Proc.new { |arg| arg < 5 })
    assert !matcher.matches?([99])
  end

  def test_should_describe_matcher
    matcher = matches_fn(Proc.new { })
    assert_equal "matches_fn()", matcher.mocha_inspect
  end

end
