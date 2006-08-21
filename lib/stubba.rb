require 'stubba/object'
require 'smart_test_case'
require 'stubba/setup_and_teardown'
require 'shared/backtracefilter'

class Test::Unit::TestCase
  include SetupAndTeardown unless ancestors.include?(SetupAndTeardown)
end
