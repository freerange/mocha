require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

class SettingExpectationOnPrivateMethodTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_setting_expectation_on_private_method_inherited_from_kernel
    instance = Class.new.new

    instance.expects(:warn)
    instance.warn
  end

  def test_setting_expectation_on_private_method_inherited_from_kernel_when_class_implements_method_missing
    instance = Class.new do
      def method_missing(*args)
      end
    end.new

    instance.expects(:warn)
    instance.warn
  end
end
