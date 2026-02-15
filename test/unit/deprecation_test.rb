# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

require 'execution_point'
require 'mocha/deprecation'

class DeprecationTest < Minitest::Test
  def test_output_deprecation_warning_to_stderr_with_source_location
    execution_point = nil
    _, stderr = capture_io do
      Mocha::Deprecation.warning('test-message'); execution_point = ExecutionPoint.current
    end
    assert_equal "Mocha deprecation warning at #{execution_point.location}: test-message", stderr.chomp
  end
end
