require 'stubba/object'
require 'smart_test_case'
require 'stubba/setup_and_teardown'
require 'shared/backtracefilter'

class Test::Unit::TestCase
  include Stubba::SetupAndTeardown unless ancestors.include?(Stubba::SetupAndTeardown)
end
