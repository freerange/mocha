require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/base'
require 'deprecation_disabler'
require 'mocha/deprecation'

class BaseTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def test_should_deprecate_inheriting_from_base_matcher_class
    subclass = nil
    DeprecationDisabler.disable_deprecations do
      subclass = Class.new(Base)
    end
    assert_includes(
      Mocha::Deprecation.messages,
      "Include #{BaseMethods} module into #{subclass} instead of inheriting from #{Base}."
    )
  end
end
