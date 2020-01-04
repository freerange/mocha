require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnClassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stubbed_instance
    method_owner.new
  end
end

class StubInstanceMethodDefinedOnClassAndAliasedTest < StubInstanceMethodDefinedOnClassTest
  def stub_aliased_method
    true
  end
end

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

class StubInstanceMethodDefinedOnModuleTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Module.new
  end

  def stubbed_instance
    Class.new.send(:include, method_owner).new
  end
end

class StubInstanceMethodDefinedOnObjectClassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    Object
  end

  def stubbed_instance
    Class.new.new
  end
end

class StubInstanceMethodDefinedOnSingletonClassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.singleton_class
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new.new
  end
end

class StubInstanceMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stubbed_instance
    Class.new(method_owner).new
  end
end

unless Mocha::PRE_RUBY_V19
  class StubMethodDefinedOnModuleAndAliasedTest < Mocha::TestCase
    include StubMethodSharedTests

    def method_owner
      @method_owner ||= Module.new
    end

    def stubbed_instance
      Class.new.send(:extend, method_owner)
    end

    def stub_aliased_method
      true
    end
  end
end
