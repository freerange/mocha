require 'smart_test_case/multiple_setup_and_teardown'

class Test::Unit::TestCase
  include MultipleSetupAndTeardown unless ancestors.include?(MultipleSetupAndTeardown)
end