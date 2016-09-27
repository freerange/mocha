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
      return if RUBY_V2_PLUS
      return unless @original_method && @original_method.owner == stubbee
      stubbee.send(:define_method, method_name, @original_method)
      Module.instance_method(@original_visibility).bind(stubbee).call(method_name)
    end

    def method_visibility(method_name)
      (stubbee.public_instance_methods(true).include?(method_name) && :public) ||
        (stubbee.protected_instance_methods(true).include?(method_name) && :protected) ||
        (stubbee.private_instance_methods(true).include?(method_name) && :private)
    end

    private

    def original_method(method_name)
      stubbee.instance_method(method_name)
    end

    def original_method_defined_on_stubbee?
      @original_method && @original_method.owner == stubbee
    end

    def remove_original_method_from_stubbee
      stubbee.send(:remove_method, method_name)
    end

    def prepend_module
      @definition_target = PrependedModule.new
      stubbee.__send__ :prepend, @definition_target
    end

    def stub_method_definition
      method_implementation = <<-CODE
      def #{method_name}(*args, &block)
        self.class.any_instance.mocha.method_missing(:#{method_name}, *args, &block)
      end
      CODE
      [method_implementation, __FILE__, __LINE__ - 4]
    end

    def definition_target
      @definition_target ||= stubbee
    end
  end
end
