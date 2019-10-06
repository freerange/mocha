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

    private

    def original_method_body
      original_method
    end

    def store_original_method
      @original_method = original_method_owner.instance_method(method_name)
    end

    def stub_method_definition
      method_implementation = <<-CODE
      def #{method_name}(*args, &block)
        self.class.any_instance.mocha.method_missing(:#{method_name}, *args, &block)
      end
      CODE
      [method_implementation, __FILE__, __LINE__ - 4]
    end

    def original_method_owner
      stubbee
    end
  end
end
