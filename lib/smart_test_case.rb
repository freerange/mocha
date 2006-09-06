require 'smart_test_case/multiple_setup_and_teardown'

class Test::Unit::TestCase
  include SmartTestCase::MultipleSetupAndTeardown unless ancestors.include?(SmartTestCase::MultipleSetupAndTeardown)
end