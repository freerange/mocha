require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/proc'
require 'mocha/inspect'

class ProcTest < Test::Unit::TestCase

  include Mocha::ParameterMatchers

  def test_should_match_returning_truthy
    matcher = Proc.new(proc { |parameter| parameter })
    assert matcher.matches?([true])
    assert matcher.matches?([1])
    assert matcher.matches?([''])
  end

  def test_should_not_match_returning_falsy
    matcher = Proc.new(proc { |parameter| parameter })
    assert !matcher.matches?([false])
    assert !matcher.matches?([nil])
  end

  def test_should_describe_matcher
    matcher = Proc.new(proc {})
    assert_equal "proc", matcher.mocha_inspect
  end

end
