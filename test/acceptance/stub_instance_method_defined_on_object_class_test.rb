require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnObjectClassTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def stubbed_module
    Object
  end

  def stubbed_class
    Class.new
  end
end
