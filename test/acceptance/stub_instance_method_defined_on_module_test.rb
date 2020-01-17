require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnModuleTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Module.new
  end

  def callee
    Class.new.send(:include, method_owner).new
  end
end
