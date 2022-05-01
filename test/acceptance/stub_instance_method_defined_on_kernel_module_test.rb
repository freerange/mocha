require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnKernelStubbedOnAnObjectTest < Mocha::TestCase
  def method_owner
    Kernel
  end

  def callee
    Class.new.new
  end
end

class StubInstanceMethodDefinedOnKernelStubbedOnAModuleTest < Mocha::TestCase
  def method_owner
    Kernel
  end

  def callee
    Module.new
  end
end
