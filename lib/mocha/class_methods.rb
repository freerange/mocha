require 'mocha/mockery'
require 'mocha/stubbed_method'

module Mocha
  # Methods added to all classes to allow mocking and stubbing on real (i.e. non-mock) objects.
  module ClassMethods
    # @private
    class AnyInstance
      def initialize(klass)
        @klass = klass
      end

      def mocha(instantiate = true)
        if instantiate
          @mocha ||= Mocha::Mockery.instance.mock_impersonating_any_instance_of(@klass)
        else
          defined?(@mocha) ? @mocha : nil
        end
      end

      def build_stubbed_method(method_name)
        Mocha::StubbedMethod.new(@klass, @klass.any_instance, @klass, method_name)
      end

      def stubba_class
        @klass
      end

      def respond_to?(symbol, include_all = false)
        @klass.allocate.respond_to?(symbol.to_sym, include_all)
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

    # @private
    # rubocop:disable Metrics/CyclomaticComplexity
    def __method_visibility__(method, include_public_methods = true)
      (include_public_methods && public_method_defined?(method) && :public) ||
        (protected_method_defined?(method) && :protected) ||
        (private_method_defined?(method) && :private)
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    alias_method :__method_exists__?, :__method_visibility__
  end
end
