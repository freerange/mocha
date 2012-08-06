require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha'
require 'deprecation_disabler'

class IntegrationModuleRenameDeprecationTest < Test::Unit::TestCase

  include DeprecationDisabler

  def test_should_display_deprecation_warning_if_integration_module_is_referenced
    disable_deprecations { Mocha::Integration }
    expected_message = "Mocha::Integration is an internal module and will soon be removed/re-purposed. Please do not use it."
    assert Mocha::Deprecation.messages.include?(expected_message)
  end
end
