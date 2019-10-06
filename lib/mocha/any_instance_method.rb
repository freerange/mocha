require 'mocha/ruby_version'
require 'mocha/class_method'

module Mocha
  class AnyInstanceMethod < ClassMethod
    private

    def mock_owner
      stubbee.any_instance
    end

    def original_method_body
      original_method
    end

    def store_original_method
      @original_method = original_method_owner.instance_method(method_name)
    end

    def stub_method_body(method_name)
      self_in_scope = self
      proc { |*args, &block| self_in_scope.mock.method_missing(method_name, *args, &block) }
    end

    def original_method_owner
      stubbee
    end
  end
end
