require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stubbed_instance
    Class.new(method_owner).new
  end
end
