require File.expand_path('../../test_helper', __FILE__)
require 'mocha/inspect'

class StringInspectTest < Mocha::TestCase

  def test_should_replace_escaped_quotes_with_single_quote
    string = "my_string"
    assert_equal "'my_string'", string.mocha_inspect
  end

  def test_should_not_replace_quotes_in_the_actual_string
	string = '"'
	assert_equal "'\"'", string.mocha_inspect
  end

  def test_should_escape_single_quotes
	string = "'"
	assert_equal "'\\''", string.mocha_inspect
  end

end
