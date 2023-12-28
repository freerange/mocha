require 'ruby2_keywords'
require 'mocha/ruby_version'

module Mocha
  class StubbedMethod
    PrependedModule = Class.new(Module)

    attr_reader :stubbee, :method_name

    def initialize(stubbee, method_name)
      @stubbee = stubbee
      @original_method = nil
      @method_name = method_name.to_sym
    end

    def stub
      visibility = original_method_owner.__method_visibility__(method_name)
      use_prepended_module_for_stub_method

      self_in_scope = self
      method_name_in_scope = method_name
      stub_method_owner.send(:define_method, method_name) do |*args, &block|
        self_in_scope.mock.handle_method_call(method_name_in_scope, args, block)
      end
      stub_method_owner.send(:ruby2_keywords, method_name)
      Module.instance_method(visibility).bind(stub_method_owner).call(method_name) if visibility
    end

    def unstub
      remove_new_method
      mock.unstub(method_name.to_sym)
      return if mock.any_expectations?
      reset_mocha
    end

    def mock
      mock_owner.mocha
    end

    def reset_mocha
      mock_owner.reset_mocha
    end

    def remove_new_method
      stub_method_owner.send(:remove_method, method_name)
    end

    def matches?(other)
      return false unless other.class == self.class
      (stubbee.object_id == other.stubbee.object_id) && (method_name == other.method_name)
    end

    alias_method :==, :eql?

    def to_s
      "#{stubbee}.#{method_name}"
    end

    private

    def use_prepended_module_for_stub_method
      @stub_method_owner = PrependedModule.new
      original_method_owner.__send__ :prepend, @stub_method_owner
    end

    def stub_method_owner
      @stub_method_owner ||= original_method_owner
    end

    def mock_owner
      raise NotImplementedError
    end

    def stubbee_method(_method_name)
      raise NotImplementedError
    end

    def original_method_owner
      raise NotImplementedError
    end
  end
end
