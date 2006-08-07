require 'multiple_setup_and_teardown'
require 'mocha/auto_verify'

class Test::Unit::TestCase
  include MultipleSetupAndTeardown unless ancestors.include?(MultipleSetupAndTeardown)
  include AutoVerify unless ancestors.include?(AutoVerify)
end