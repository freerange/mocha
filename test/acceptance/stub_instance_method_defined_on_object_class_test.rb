require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnObjectClassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    Object
  end

  def stubbed_instance
    Class.new.new
  end
end
