require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stubbed_instance
    Class.new(method_owner).new
  end
end
