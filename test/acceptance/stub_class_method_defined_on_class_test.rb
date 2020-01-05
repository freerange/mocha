require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubClassMethodDefinedOnClassTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def method_owner
    stubbed_instance.singleton_class
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new
  end
end
