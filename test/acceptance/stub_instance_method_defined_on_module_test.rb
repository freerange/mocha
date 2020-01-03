require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnModuleTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def stubbed_module
    @stubbed_module ||= Module.new
  end

  def stubbed_class
    Class.new.send(:include, stubbed_module)
  end
end
