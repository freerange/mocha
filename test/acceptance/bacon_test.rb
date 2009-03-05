require File.join(File.dirname(__FILE__), "acceptance_test_helper")

begin
  require 'bacon'
rescue LoadError
  # Bacon not available
end

if defined?(Bacon) && Bacon::VERSION >= "1.1"

  class BaconRunner

    attr_reader :output, :tests, :assertions, :failures, :errors

    def initialize(*paths)
      @paths = paths
    end

    def run(name)
      @output = `bacon -n '#{name}' #{@paths.join(' ')}`
      numbers = @output.scan(/(\d+) tests, (\d+) assertions, (\d+) failures, (\d+) errors/)
      numbers.flatten!.map!{|e| e.to_i}

      @tests = numbers[0]
      @assertions = numbers[1]
      @failures = numbers[2]
      @errors = numbers[3]
    end

  end

  class BaconTest < Test::Unit::TestCase

    def setup
      @runner = BaconRunner.new("#{File.dirname(__FILE__)}/bacon_spec.rb")
    end

    def test_should_pass_mocha_test

      @runner.run('should pass when all expectations were fulfilled')

      assert_equal 0, @runner.errors
      assert_equal 1, @runner.tests
    end

    def test_should_fail_mocha_test_due_to_unfulfilled_expectation

      @runner.run('should fail when not all expectations were fulfilled')

      assert_equal 1, @runner.errors
      assert_equal 1, @runner.tests
      assert_not_all_expectation_were_satisfied(@runner.output)

    end

    def test_should_fail_mocha_test_due_to_unexpected_invocation
      @runner.run('should fail when there is an unexpected invocation')
      
      assert_equal 1, @runner.errors
      assert_equal 1, @runner.tests
      assert_unexpected_invocation(@runner.output)
    end

  
    def test_should_pass_stubba_test
      @runner.run('should pass when all Stubba expectations are fulfilled')
    
      assert_equal 0, @runner.errors
      assert_equal 1, @runner.tests
    end
  
    def test_should_fail_stubba_test_due_to_unfulfilled_expectation
      @runner.run('should fail when not all Stubba expectations were fulfilled')

      assert_equal 1, @runner.errors
      assert_equal 1, @runner.tests
      assert_not_all_expectation_were_satisfied(@runner.output)
    end
  
    def test_should_pass_mocha_test_with_matching_parameter
      @runner.run('should pass when they receive all expected parameters')

      assert_equal 0, @runner.errors
      assert_equal 1, @runner.tests
    end
  
    def test_should_fail_mocha_test_with_non_matching_parameter
      @runner.run('should fail when they receive unexpected parameters')

      assert_equal 1, @runner.errors
      assert_equal 1, @runner.tests
      assert_unexpected_invocation(@runner.output)
    end

    private

    def assert_unexpected_invocation(string)
      assert_match Regexp.new('unexpected invocation'), string, "Bacon output:\n#{string}"
    end

    def assert_not_all_expectation_were_satisfied(string)
      assert_match Regexp.new('not all expectations were satisfied'), string, "Bacon output:\n#{string}"
    end

  end

else
  warn "Bacon is not available, so BaconTest has not been run."
end

