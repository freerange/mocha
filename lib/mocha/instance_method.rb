require 'mocha/stubbed_method'

module Mocha
  class InstanceMethod < StubbedMethod
    private

    def stubbee
      stubba_object
    end

    def method_body(method)
      PRE_RUBY_V19 ? proc { |*args, &block| method.call(*args, &block) } : method
    end

    def stubbee_method(method_name)
      stubba_object._method(method_name)
    end

    def original_method_owner
      stubba_object.singleton_class
    end
  end
end
