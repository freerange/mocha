require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubClassMethodDefinedOnModuleTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    @method_owner ||= Module.new
  end

  def stubbed_instance
    Class.new.extend(method_owner)
  end
end
