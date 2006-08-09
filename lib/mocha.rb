require 'smart_test_case'
require 'mocha/auto_verify'

class Test::Unit::TestCase
  include AutoVerify unless ancestors.include?(AutoVerify)
end