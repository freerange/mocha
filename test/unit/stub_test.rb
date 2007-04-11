require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/stub'

class StubTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_always_verify_successfully
    stub = Stub.new(nil, :expected_method)
    assert stub.verify
    stub.invoke
    assert stub.verify
  end
  
end