require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnClassTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def stubbed_module
    @stubbed_module ||= Class.new
  end

  def stubbed_class
    stubbed_module
  end
end
