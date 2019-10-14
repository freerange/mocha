require 'mocha/mockery'
require 'mocha/any_instance_method'

module Mocha
  # Methods added to all classes to allow mocking and stubbing on real (i.e. non-mock) objects.
  module ClassMethods
    # @private
    class AnyInstance
      def initialize(klass)
        @stubba_object = klass
      end

      def mocha(instantiate = true)
        if instantiate
          @mocha ||= Mocha::Mockery.instance.mock_impersonating_any_instance_of(@stubba_object)
        else
          defined?(@mocha) ? @mocha : nil
        end
      end

      def stubba_method
        Mocha::AnyInstanceMethod
      end

      def respond_to?(method)
        @stubba_object.allocate.respond_to?(method.to_sym)
      end

      def singleton_class
        @stubba_object
      end

      attr_reader :stubba_object
    end

    # @return [Mock] a mock object which will detect calls to any instance of this class.
    # @raise [StubbingError] if attempting to stub method which is not allowed.
    #
    # @example Return false to invocation of +Product#save+ for any instance of +Product+.
    #   Product.any_instance.stubs(:save).returns(false)
    #   product_1 = Product.new
    #   assert_equal false, product_1.save
    #   product_2 = Product.new
    #   assert_equal false, product_2.save
    def any_instance
      if frozen?
        raise StubbingError.new("can't stub method on frozen object: #{mocha_inspect}.any_instance", caller)
      end
      @any_instance ||= AnyInstance.new(self)
    end

    def method_visibility(method, include_public_methods = true)
      (include_public_methods && public_method_defined?(method) && :public) ||
        (protected_method_defined?(method) && :protected) ||
        (private_method_defined?(method) && :private)
    end
    alias_method :method_exists?, :method_visibility
  end
end
