require File.expand_path('../../test_helper', __FILE__)
require 'mocha/inspect'
require 'mocha/ruby_version'

class HashInspectTest < Mocha::TestCase
  def test_should_return_string_representation_of_hash
    hash = { a: true, b: false }
    assert_equal '{:a => true, :b => false}', hash.mocha_inspect
  end

  if Mocha::RUBY_V27_PLUS
    def test_should_return_unwrapped_keyword_style_hash_when_keyword_hash
      hash = Hash.ruby2_keywords_hash(a: true, b: false)
      assert_equal 'a: true, b: false', hash.mocha_inspect
    end

    def test_should_return_unwrapped_hash_when_keyword_hash_keys_are_not_symbols
      hash = Hash.ruby2_keywords_hash('a' => true, 'b' => false)
      assert_equal '"a" => true, "b" => false', hash.mocha_inspect
    end
  end

  def test_should_use_mocha_inspect_on_each_key_and_value
    hash = { a: 'mocha' }
    assert_equal %({:a => "mocha"}), hash.mocha_inspect
  end
end
