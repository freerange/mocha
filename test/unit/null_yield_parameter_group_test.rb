require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'mocha/null_yield_parameter_group'

class NullYieldParameterGroupTest < Test::Unit::TestCase
  
  include Mocha

  def test_should_provide_parameters_for_no_yields_in_single_invocation
    parameter_group = NullYieldParameterGroup.new
    parameter_groups = []
    parameter_group.each do |parameters|
      parameter_groups << parameters
    end
    assert_equal [], parameter_groups
  end
  
end
