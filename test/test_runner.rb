# frozen_string_literal: true

require 'assertions'

require 'mocha/detection/minitest'

module TestRunner
  def run_as_test(&block)
    run_as_tests(test_me: block)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def run_as_tests(methods = {})
    base_class = Mocha::TestCase
    test_class = Class.new(base_class) do
      def self.name;
        'FakeTest'
      end

      include Assertions

      methods.each do |(method_name, proc)|
        define_method(method_name, proc)
      end
    end

    tests = methods.keys.select { |m| m.to_s[/^test/] }.map { |m| test_class.new(m) }

    if Mocha::Detection::Minitest.testcase && (ENV['MOCHA_RUN_INTEGRATION_TESTS'] != 'test-unit')
      minitest_version = Gem::Version.new(Mocha::Detection::Minitest.version)
      if Gem::Requirement.new('>= 5.0.0').satisfied_by?(minitest_version)
        require File.expand_path('../minitest_result', __FILE__)
        tests.each(&:run)
        Minitest::Runnable.runnables.delete(test_class)
        test_result = MinitestResult.new(tests)
      elsif Gem::Requirement.new('> 0.0.0', '< 5.0.0').satisfied_by?(minitest_version)
        require File.expand_path('../minitest_result_pre_v5', __FILE__)
        runner = Minitest::Unit.new
        tests.each do |test|
          test.run(runner)
        end
        test_result = MinitestResultPreV5.new(runner, tests)
      end
    else
      require File.expand_path('../test_unit_result', __FILE__)
      test_result = TestUnitResult.build_test_result
      tests.each do |test|
        test.run(test_result) {}
      end
    end

    test_result
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def assert_passed(test_result)
    flunk "Test errored unexpectedly with message: #{test_result.errors.map(&:exception)}" if test_result.error_count > 0
    flunk "Test failed unexpectedly with message: #{test_result.failures}" if test_result.failure_count > 0
  end

  def assert_failed(test_result)
    flunk "Test errored unexpectedly with message: #{test_result.errors.map(&:exception)}" if test_result.error_count > 0
    flunk 'Test passed unexpectedly' unless test_result.failure_count > 0
  end

  def assert_errored(test_result)
    flunk 'Test did not error as expected' unless test_result.error_count > 0
  end
end
