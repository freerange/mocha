require 'smart_test_case'
require 'mocha/auto_verify'
require 'mocha/backtracefilter'

class Test::Unit::TestCase
  include AutoVerify unless ancestors.include?(AutoVerify)
end