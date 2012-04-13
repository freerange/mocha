require 'test/unit/testcase'

if defined?(MiniTest)
  require 'mocha/integration/mini_test'
  require File.expand_path('../mini_test_result', __FILE__)
else
  require File.expand_path('../test_unit_result', __FILE__)
end

module TestRunner
  def run_as_test(&block)
    test_class = Class.new(Test::Unit::TestCase) do
      define_method(:test_me, &block)
    end
    test = test_class.new(:test_me)

    if defined?(Test::Unit::TestResult)
      test_result = TestUnitResult.build_test_result
      test.run(test_result) {}
    else
      runner = MiniTest::Unit.new
      test.run(runner)
      test_result = MiniTestResult.new(runner, test)
    end

    test_result
  end

  def assert_passed(test_result)
    flunk "Test failed unexpectedly with message: #{test_result.failures}" if test_result.failure_count > 0
    flunk "Test failed unexpectedly with message: #{test_result.errors}" if test_result.error_count > 0
  end

  def assert_failed(test_result)
    flunk "Test passed unexpectedly" if test_result.passed?
  end

end
