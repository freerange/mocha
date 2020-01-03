require File.expand_path('../stub_instance_method_shared_tests', __FILE__)

unless Mocha::PRE_RUBY_V19
  class StubMethodDefinedOnModuleAndAliasedTest < Mocha::TestCase
    include StubInstanceMethodSharedTests

    def method_owner
      @method_owner ||= Module.new
    end

    def stubbed_instance
      Class.new.extend(method_owner)
    end

    def alias_method?
      true
    end
  end
end
