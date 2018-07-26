require 'mocha/mockery'
require 'mocha/class_method'
require 'mocha/any_instance_method'

module Mocha
  # Methods added to all classes to allow mocking and stubbing on real (i.e. non-mock) objects.
  module ClassMethods
    # @private
    def stubba_method
      Mocha::ClassMethod
    end

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

      attr_reader :stubba_object

      def method_exists?(method, include_public_methods = true)
        if include_public_methods
          return true if @stubba_object.public_instance_methods(true).include?(method)
          return true if @stubba_object.allocate.respond_to?(method.to_sym)
        end
        return true if @stubba_object.protected_instance_methods(true).include?(method)
        return true if @stubba_object.private_instance_methods(true).include?(method)
        false
      end
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
  end
end
