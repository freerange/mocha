# frozen_string_literal: true

require 'assertions'
require 'deprecation_capture'

require 'mocha/detection/minitest'

module TestRunner
  def run_as_test(&block)
    run_as_tests(test_me: block)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def run_as_tests(methods = {})
    base_class = Mocha::TestCase
    test_class = Class.new(base_class) do
      def self.name;
        'FakeTest'
      end

      include Assertions, DeprecationCapture

      methods.each do |(method_name, proc)|
        define_method(method_name, proc)
      end
    end

    tests = methods.keys.select { |m| m.to_s[/^test/] }.map { |m| test_class.new(m) }

    if Mocha::Detection::Minitest.testcase && (ENV['MOCHA_RUN_INTEGRATION_TESTS'] != 'test-unit')
      minitest_version = Gem::Version.new(Mocha::Detection::Minitest.version)
      minitest_version_supported = Gem::Requirement.new('>= 5.0.0').satisfied_by?(minitest_version)
      raise "Minitest v#{minitest_version} not supported" unless minitest_version_supported

      require File.expand_path('../minitest_result', __FILE__)
      tests.each(&:run)
      Minitest::Runnable.runnables.delete(test_class)
      test_result = MinitestResult.new(tests)
    else
      require File.expand_path('../test_unit_result', __FILE__)
      test_result = TestUnitResult.build_test_result
      tests.each do |test|
        test.run(test_result) {}
      end
    end

    test_result.tap { |r| r.last_deprecation_warning = tests.flat_map(&:deprecation_warnings).last }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

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
