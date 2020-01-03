require File.expand_path('../stub_method_shared_tests', __FILE__)

unless Mocha::PRE_RUBY_V19
  class StubMethodDefinedOnModuleAndAliasedTest < Mocha::TestCase
    include StubMethodSharedTests

    def method_owner
      @method_owner ||= Module.new
    end

    def stubbed_instance
      Class.new.send(:extend, method_owner)
    end

    def stub_aliased_method
      true
    end
  end
end
