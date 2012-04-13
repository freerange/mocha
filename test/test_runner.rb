require 'test/unit/testcase'

if defined?(MiniTest)
  require 'mocha/integration/mini_test'
  require File.expand_path('../mini_test_result', __FILE__)
else
  require File.expand_path('../test_unit_result', __FILE__)
end

module TestRunner
  def run_as_test(&block)
    run_as_tests(block)
  end

  def run_as_tests(*procs)
    tests = procs.map do |proc|
      test_class = Class.new(Test::Unit::TestCase) do
        define_method(:test_me, proc)
      end
      test_class.new(:test_me)
    end

    if defined?(Test::Unit::TestResult)
      test_result = TestUnitResult.build_test_result
      tests.each do |test|
        test.run(test_result) {}
      end
    else
      runner = MiniTest::Unit.new
      tests.each do |test|
        test.run(runner)
      end
      test_result = MiniTestResult.new(runner, tests)
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
