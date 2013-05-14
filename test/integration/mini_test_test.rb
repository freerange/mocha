require File.expand_path('../../test_helper', __FILE__)

begin
  require "minitest"
rescue LoadError
end
begin
  require "minitest/unit"
rescue LoadError
end

require "mocha/setup"
require "integration/shared_tests"

if defined?(::Minitest) || defined?(MiniTest)
  testcase = defined?(Minitest::Test) ? Minitest::Test : MiniTest::Unit::TestCase
  class MiniTestTest < testcase
    include SharedTests
  end
else
  puts "MiniTest not available - no point in running tests."
end