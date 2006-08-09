require 'stubba/object'
require 'smart_test_case'
require 'stubba/setup_and_teardown'

class Test::Unit::TestCase
  include SetupAndTeardown unless ancestors.include?(SetupAndTeardown)
end
