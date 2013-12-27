require File.expand_path('../../test_helper', __FILE__)

begin
  require "minitest"
rescue LoadError
end
begin
  require "minitest/unit"
rescue LoadError
end

require "mocha/integration/mini_test"
require "mocha/detection/mini_test"
require "integration/shared_tests"

Mocha::Integration::MiniTest.activate

if testcase = Mocha::Detection::MiniTest.testcase
  class MiniTestTest < testcase
    include SharedTests
  end
else
  puts "MiniTest not available - no point in running tests."
end