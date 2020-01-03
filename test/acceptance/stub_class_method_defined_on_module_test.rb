require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

class StubClassMethodDefinedOnModuleTest < Mocha::TestCase
  include StubInstanceMethodSharedTests

  def method_owner
    @method_owner ||= Module.new
  end

  def stubbed_instance
    Class.new.extend(method_owner)
  end
end
