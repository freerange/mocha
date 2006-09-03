require 'smart_test_case'
require 'mocha/auto_verify'
require 'shared/backtracefilter'

class Test::Unit::TestCase
  include Mocha::AutoVerify unless ancestors.include?(Mocha::AutoVerify)
end