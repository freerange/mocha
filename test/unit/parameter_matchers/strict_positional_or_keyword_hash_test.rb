# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/positional_or_keyword_hash'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'
require 'mocha/expectation'
require 'mocha/ruby_version'
require 'mocha/configuration'

if Mocha::RUBY_V27_PLUS
  class StrictPositionalOrKeywordHashTest < Mocha::TestCase
    include Mocha::ParameterMatchers

    def setup
      @original = Mocha.configuration.strict_keyword_argument_matching?
      Mocha.configure { |c| c.strict_keyword_argument_matching = true }
    end

    def teardown
      Mocha.configure { |c| c.strict_keyword_argument_matching = @original }
    end

    def test_expected_hash_should_match_actual_non_last_hash
      matcher = build_matcher({ key_1: 1, key_2: 2 })
      assert matcher.matches?([{ key_1: 1, key_2: 2 }, %w[a b]])
    end

    def test_expected_hash_should_not_match_actual_non_hash
      matcher = build_matcher({ key_1: 1, key_2: 2 })
      assert !matcher.matches?([%w[a b]])
    end

    def test_expected_hash_should_match_actual_hash
      matcher = build_matcher({ key_1: 1, key_2: 2 })
      assert matcher.matches?([{ key_1: 1, key_2: 2 }])
    end

    def test_expected_keywords_hash_should_match_actual_keywords_hash
      matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }))
      assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
    end

    def test_expected_keywords_hash_should_not_match_actual_hash
      matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }))
      assert !matcher.matches?([{ key_1: 1, key_2: 2 }])
    end

    def test_expected_last_hash_should_match_actual_keywords_hash
      matcher = build_matcher({ key_1: 1, key_2: 2 })
      assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
    end

    private

    def build_matcher(hash)
      Mocha::ParameterMatchers::PositionalOrKeywordHash.new(hash, nil)
    end
  end
end
