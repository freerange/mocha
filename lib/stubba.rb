require 'stubba/object'
require 'multiple_setup_and_teardown'
require 'stubba/setup_and_teardown'

class Test::Unit::TestCase
  include MultipleSetupAndTeardown unless ancestors.include?(MultipleSetupAndTeardown)
  include SetupAndTeardown unless ancestors.include?(SetupAndTeardown)
end
