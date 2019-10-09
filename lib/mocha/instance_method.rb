require 'mocha/stubbed_method'

module Mocha
  class InstanceMethod < StubbedMethod
    private

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

    def stubbee_method
      stubbee._method(method_name)
    end

    def original_method_owner
      stubbee.singleton_class
    end
  end
end
