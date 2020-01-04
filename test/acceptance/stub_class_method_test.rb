require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubClassMethodDefinedOnClassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.singleton_class
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new
  end
end

class StubClassMethodDefinedOnModuleTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Module.new
  end

  def stubbed_instance
    Class.new.extend(method_owner)
  end
end

class StubClassMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.superclass.singleton_class
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new(Class.new)
  end
end
