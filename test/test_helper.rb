# frozen_string_literal: true

unless defined?(STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS)
  STANDARD_OBJECT_PUBLIC_INSTANCE_METHODS = Object.instance_methods + Object.private_instance_methods
end

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__)))
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'unit'))
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'acceptance'))

require 'mocha/detection/minitest'

begin
  require 'minitest'
rescue LoadError
  warn "Unable to load 'minitest', but continuing anyway" if $DEBUG
end
module Mocha; end

if (minitest_testcase = Mocha::Detection::Minitest.testcase) && (ENV['MOCHA_RUN_INTEGRATION_TESTS'] != 'test-unit')
  begin
    require 'minitest/autorun'
  rescue LoadError
    Minitest::Unit.autorun
  end
  # rubocop:disable Style/ClassAndModuleChildren
  class Mocha::TestCase < minitest_testcase
    def assert_nothing_raised(exception = StandardError)
      yield
    rescue exception => e
      flunk "Unexpected exception raised: #{e}"
    end

    alias_method :assert_not_nil, :refute_nil
    alias_method :assert_raise, :assert_raises
    alias_method :assert_not_same, :refute_same
    alias_method :assert_no_match, :refute_match
  end
  # rubocop:enable Style/ClassAndModuleChildren
else
  require 'test/unit'
  # rubocop:disable Style/ClassAndModuleChildren
  class Mocha::TestCase < Test::Unit::TestCase
    def test_dummy
      # Some versions (?) of Test::Unit try to run this base class as a test case
      # and it fails because it has no test methods, so I'm adding a dummy test.
    end
  end
  # rubocop:enable Style/ClassAndModuleChildren
end
