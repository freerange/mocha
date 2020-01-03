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
