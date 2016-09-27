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
      unless RUBY_V2_PLUS
        if @original_method && @original_method.owner == stubbee
          stubbee.send(:define_method, method, @original_method)
          Module.instance_method(@original_visibility).bind(stubbee).call(method)
        end
      end
    end

    def method_visibility(method)
      (stubbee.public_instance_methods(true).include?(method) && :public) ||
        (stubbee.protected_instance_methods(true).include?(method) && :protected) ||
        (stubbee.private_instance_methods(true).include?(method) && :private)
    end

    private

    def original_method(method)
      stubbee.instance_method(method)
    end

    def original_method_defined_on_stubbee?
      @original_method && @original_method.owner == stubbee
    end

    def remove_original_method_from_stubbee
      stubbee.send(:remove_method, method)
    end

    def prepend_module
      @definition_target = PrependedModule.new
      stubbee.__send__ :prepend, @definition_target
    end

    def stub_method_definition
      filename, line_number_of_method_implementation = __FILE__, __LINE__ + 2
      method_implementation = <<-CODE
      def #{method}(*args, &block)
        self.class.any_instance.mocha.method_missing(:#{method}, *args, &block)
      end
      CODE
      [method_implementation, filename, line_number_of_method_implementation]
    end

    def definition_target
      @definition_target ||= stubbee
    end

  end

end
