require File.expand_path('../../test_helper', __FILE__)
require 'mocha/configuration'
require 'mocha/ruby_version'

class ConfigurationTest < Mocha::TestCase
  def teardown
    Mocha::Configuration.reset_configuration
  end

  def test_allow_temporarily_changes_config_when_given_block
    Mocha.configure { |c| c.stubbing_method_unnecessarily = :warn }
    yielded = false
    Mocha::Configuration.override(:stubbing_method_unnecessarily => :allow) do
      yielded = true
      assert_equal :allow, Mocha.configuration.stubbing_method_unnecessarily
    end
    assert yielded
    assert_equal :warn, Mocha.configuration.stubbing_method_unnecessarily
  end

  def test_prevent_temporarily_changes_config_when_given_block
    Mocha.configure { |c| c.stubbing_method_unnecessarily = :allow }
    yielded = false
    Mocha::Configuration.override(:stubbing_method_unnecessarily => :prevent) do
      yielded = true
      assert_equal :prevent, Mocha.configuration.stubbing_method_unnecessarily
    end
    assert yielded
    assert_equal :allow, Mocha.configuration.stubbing_method_unnecessarily
  end

  def test_warn_when_temporarily_changes_config_when_given_block
    Mocha.configure { |c| c.stubbing_method_unnecessarily = :allow }
    yielded = false
    Mocha::Configuration.override(:stubbing_method_unnecessarily => :warn) do
      yielded = true
      assert_equal :warn, Mocha.configuration.stubbing_method_unnecessarily
    end
    assert yielded
    assert_equal :allow, Mocha.configuration.stubbing_method_unnecessarily
  end

  def test_strict_keyword_argument_matching_works_is_false_by_default
    assert !Mocha.configuration.strict_keyword_argument_matching?
  end

  if Mocha::RUBY_V27_PLUS
    def test_enabling_strict_keyword_argument_matching_works_in_ruby_2_7_and_above
      Mocha.configure { |c| c.strict_keyword_argument_matching = true }
      assert Mocha.configuration.strict_keyword_argument_matching?
    end
  else
    def test_enabling_strict_keyword_argument_matching_raises_error_if_below_ruby_2_7
      assert_raises(RuntimeError, 'Strict keyword argument matching requires Ruby 2.7 and above.') do
        Mocha.configure { |c| c.strict_keyword_argument_matching = true }
      end
    end
  end
end
