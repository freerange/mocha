require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnKernelStubbedOnAnObjectTest < Mocha::TestCase
  def method_owner
    Kernel
  end

  def stubbed_instance
    Class.new.new
  end
end

class StubInstanceMethodDefinedOnKernelStubbedOnAModuleTest < Mocha::TestCase
  def method_owner
    Kernel
  end

  def stubbed_instance
    Module.new
  end
end
