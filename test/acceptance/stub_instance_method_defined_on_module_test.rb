require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubInstanceMethodDefinedOnModuleTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def method_owner
    @method_owner ||= Module.new
  end

  def stubbed_instance
    Class.new.send(:include, method_owner).new
  end
end
