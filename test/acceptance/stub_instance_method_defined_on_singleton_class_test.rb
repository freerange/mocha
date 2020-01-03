require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnSingletonClassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.singleton_class
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new.new
  end
end
