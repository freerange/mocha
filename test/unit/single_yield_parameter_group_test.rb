require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'mocha/single_yield_parameter_group'

class SingleYieldParameterGroupTest < Test::Unit::TestCase
  
  include Mocha

  def test_should_provide_parameters_for_single_yield_in_single_invocation
    parameter_group = SingleYieldParameterGroup.new(1, 2, 3)
    parameter_groups = []
    parameter_group.each do |parameters|
      parameter_groups << parameters
    end
    assert_equal [[1, 2, 3]], parameter_groups
  end
  
end
