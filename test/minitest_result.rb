# frozen_string_literal: true

require 'forwardable'

class MinitestResult
  class Failure
    extend Forwardable

    def_delegators :@failure, :message, :backtrace

    def initialize(failure)
      @failure = failure
    end

    def location
      Minitest.filter_backtrace(backtrace)
    end
  end

  attr_accessor :last_deprecation_warning

  def initialize(tests)
    @tests = tests
  end

  def failures
    @tests.map(&:failures).flatten.select { |r| r.instance_of?(Minitest::Assertion) }.map { |f| Failure.new(f) }
  end

  def failure_count
    failures.length
  end

  def failure_message_lines
    failures.map { |f| f.message.split("\n") }.flatten
  end

  def errors
    @tests.map(&:failures).flatten.select { |r| r.instance_of?(Minitest::UnexpectedError) }
  end

  def error_count
    errors.length
  end

  def error_messages
    errors.map { |e| e.message.split("\n") }.flatten
  end

  def assertion_count
    @tests.inject(0) { |total, test| total + test.assertions }
  end
end
