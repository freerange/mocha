require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/query_string'

class QueryStringMatchesTest < Mocha::TestCase

  include Mocha::ParameterMatchers

  def test_should_match_identical_query_string
    matcher = has_equivalent_query_string('http://example.com/foo?a=1&b=2')
    assert matcher.matches?(['http://example.com/foo?a=1&b=2'])
  end

  def test_should_match_rearranged_query_string
    matcher = has_equivalent_query_string('http://example.com/foo?b=2&a=1')
    assert matcher.matches?(['http://example.com/foo?a=1&b=2'])
  end

  def test_should_not_match_different_query_string
    matcher = has_equivalent_query_string('http://example.com/foo?a=1')
    assert !matcher.matches?(['http://example.com/foo?a=1&b=2'])
  end

  def test_should_not_match_query_string_when_none_expected
    matcher = has_equivalent_query_string('http://example.com/foo')
    assert !matcher.matches?(['http://example.com/foo?a=1&b=2'])
  end

  def test_should_not_match_equivalent_query_string_when_other_parts_of_url_differ
    matcher = has_equivalent_query_string('http://a.example.com/foo?a=1&b=2')
    assert !matcher.matches?(['http://b.example.com/foo?a=1&b=2'])
  end

  def test_should_match_equivalent_query_string_when_url_has_no_scheme_or_domain
    matcher = has_equivalent_query_string('/foo?a=1&b=2')
    assert matcher.matches?(['/foo?a=1&b=2'])
  end
end
