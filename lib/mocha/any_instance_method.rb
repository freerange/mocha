require 'mocha/ruby_version'
require 'mocha/class_method'

module Mocha
  class AnyInstanceMethod < ClassMethod
    def mock
      stubbee.any_instance.mocha
    end

    def reset_mocha
      stubbee.any_instance.reset_mocha
    end

    def restore_original_method
      return if use_prepended_module_for_stub_method?
      return unless original_method_defined_on_stubbee?
      default_stub_method_owner.send(:define_method, method_name, original_method)
      Module.instance_method(@original_visibility).bind(default_stub_method_owner).call(method_name)
    end

    def method_visibility(method_name)
      (default_stub_method_owner.public_instance_methods(true).include?(method_name) && :public) ||
        (default_stub_method_owner.protected_instance_methods(true).include?(method_name) && :protected) ||
        (default_stub_method_owner.private_instance_methods(true).include?(method_name) && :private)
    end

    private

    def store_original_method
      @original_method = default_stub_method_owner.instance_method(method_name)
    end

    def stub_method_definition
      method_implementation = <<-CODE
      def #{method_name}(*args, &block)
        self.class.any_instance.mocha.method_missing(:#{method_name}, *args, &block)
      end
      CODE
      [method_implementation, __FILE__, __LINE__ - 4]
    end

    def default_stub_method_owner
      stubbee
    end
  end
end
