require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def stubbed_module
    @stubbed_module ||= Class.new
  end

  def stubbed_class
    Class.new(stubbed_module)
  end
end
