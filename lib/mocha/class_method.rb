require 'mocha/ruby_version'
require 'mocha/singleton_class'

module Mocha
  class ClassMethod
    PrependedModule = Class.new(Module)

    attr_reader :stubbee, :method_name

    def initialize(stubbee, method_name)
      @stubbee = stubbee
      @original_method = nil
      @original_visibility = nil
      @method_name = PRE_RUBY_V19 ? method_name.to_s : method_name.to_sym
    end

    def stub
      hide_original_method
      define_new_method
    end

    def unstub
      remove_new_method
      restore_original_method
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

    def hide_original_method
      return unless method_defined_in_stubbee_or_in_ancestor_chain?
      store_original_method_visibility
      if use_prepended_module_for_stub_method?
        use_prepended_module_for_stub_method
      else
        begin
          store_original_method
        # rubocop:disable Lint/HandleExceptions
        rescue NameError
          # deal with nasties like ActiveRecord::Associations::AssociationProxy
        end
        # rubocop:enable Lint/HandleExceptions
        if stub_method_overwrites_original_method?
          remove_original_method_from_stubbee
        end
      end
    end

    def define_new_method
      self_in_scope = self
      method_name_in_scope = method_name
      stub_method_owner.send(:define_method, method_name) do |*args, &block|
        self_in_scope.mock.method_missing(method_name_in_scope, *args, &block)
      end
      retain_original_visibility(stub_method_owner)
    end

    def remove_new_method
      stub_method_owner.send(:remove_method, method_name)
    end

    def restore_original_method
      return if use_prepended_module_for_stub_method?
      if stub_method_overwrites_original_method?
        original_method_owner.send(:define_method, method_name, original_method_body)
      end
      retain_original_visibility(original_method_owner)
    end

    def matches?(other)
      return false unless other.class == self.class
      (stubbee.object_id == other.stubbee.object_id) && (method_name == other.method_name)
    end

    alias_method :==, :eql?

    def to_s
      "#{stubbee}.#{method_name}"
    end

    def method_visibility
      original_method_owner.method_visibility(method_name)
    end
    alias_method :method_defined_in_stubbee_or_in_ancestor_chain?, :method_visibility

    private

    def retain_original_visibility(method_owner)
      return unless original_visibility
      Module.instance_method(original_visibility).bind(method_owner).call(method_name)
    end

    attr_reader :original_method, :original_visibility

    def store_original_method_visibility
      @original_visibility = method_visibility
    end

    def stub_method_overwrites_original_method?
      original_method && original_method.owner == original_method_owner
    end

    def remove_original_method_from_stubbee
      original_method_owner.send(:remove_method, method_name)
    end

    def use_prepended_module_for_stub_method?
      RUBY_V2_PLUS
    end

    def use_prepended_module_for_stub_method
      @stub_method_owner = PrependedModule.new
      original_method_owner.__send__ :prepend, @stub_method_owner
    end

    def stub_method_owner
      @stub_method_owner ||= original_method_owner
    end

    def mock_owner
      stubbee
    end

    def original_method_body
      if PRE_RUBY_V19
        original_method_in_scope = original_method
        proc { |*args, &block| original_method_in_scope.call(*args, &block) }
      else
        original_method
      end
    end

    def store_original_method
      @original_method = stubbee._method(method_name)
    end

    def original_method_owner
      stubbee.singleton_class
    end
  end
end
