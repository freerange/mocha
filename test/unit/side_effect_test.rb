require File.expand_path('../../test_helper', __FILE__)
require 'mocha/mock'

class SideEffectTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_not_execute_code_when_runs_is_used
    updated = false
    mock = Mock.new
    mock.expects(:update).runs{updated = true}.returns("Variable 'updated' assigned 'true'")
    assert_equal false, updated
  end
  
  def test_should_execute_code_when_runs_is_used_and_stubbed_method_is_used
    updated = false
    mock = Mock.new
    mock.expects(:update).runs{updated = true}.returns("Variable 'updated' assigned 'true'")
    mock.update
    assert_equal true, updated
  end
  
end
