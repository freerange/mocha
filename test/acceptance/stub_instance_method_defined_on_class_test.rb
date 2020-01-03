require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnClassTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stubbed_instance
    method_owner.new
  end
end

class StubInstanceMethodDefinedOnClassAndAliasedTest < StubInstanceMethodDefinedOnClassTest
  def alias_method?
    true
  end
end
