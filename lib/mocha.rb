require 'mocha/object'
require 'mocha/multiple_setup_and_teardown'
require 'mocha/auto_verify'
require 'mocha/backtracefilter'
require 'mocha/setup_and_teardown'

class Test::Unit::TestCase
  include SmartTestCase::MultipleSetupAndTeardown unless ancestors.include?(SmartTestCase::MultipleSetupAndTeardown)
  include Mocha::AutoVerify unless ancestors.include?(Mocha::AutoVerify)
  include Mocha::SetupAndTeardown unless ancestors.include?(Mocha::SetupAndTeardown)
end
