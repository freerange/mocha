require 'mocha/mockery'
require 'mocha/instance_method'
require 'mocha/class_method'
require 'mocha/module_method'
require 'mocha/any_instance_method'
require 'mocha/argument_iterator'

module Mocha

  # Methods added to all objects to allow mocking and stubbing on real (i.e. non-mock) objects.
  #
  # Both {#expects} and {#stubs} return an {Expectation} which can be further modified by methods on {Expectation}.
  module ObjectMethods

    # @private
    def mocha
      @mocha ||= Mocha::Mockery.instance.mock_impersonating(self)
    end

    # @private
    def reset_mocha
      @mocha = nil
    end

    # @private
    def stubba_method
      Mocha::InstanceMethod
    end

    # @private
    def stubba_object
      self
    end

    # Adds an expectation that the specified method must be called exactly once with any parameters.
    #
    # The original implementation of the method is replaced during the test and then restored at the end of the test.
    #
    # @param [Symbol,String] method_name name of expected method
    # @param [Hash] expected_methods_vs_return_values expected method name symbols as keys and corresponding return values as values - these expectations are setup as if {#expects} were called multiple times.
    #
    # @overload def expects(method_name)
    # @overload def expects(expected_methods_vs_return_values)
    # @return [Expectation] last-built expectation which can be further modified by methods on {Expectation}.
    # @raise [StubbingError] if attempting to stub method which is not allowed.
    #
    # @example Setting up an expectation on a non-mock object.
    #   product = Product.new
    #   product.expects(:save).returns(true)
    #   assert_equal true, product.save
    #
    # @example Setting up multiple expectations on a non-mock object.
    #   product = Product.new
    #   product.expects(:valid? => true, :save => true)
    #
    #   # exactly equivalent to
    #
    #   product = Product.new
    #   product.expects(:valid?).returns(true)
    #   product.expects(:save).returns(true)
    #
    # @see Mock#expects
    def expects(expected_methods_vs_return_values)
      if expected_methods_vs_return_values.to_s =~ /the[^a-z]*spanish[^a-z]*inquisition/i
        raise Mocha::ExpectationError.new('NOBODY EXPECTS THE SPANISH INQUISITION!')
      end
      if frozen?
        raise StubbingError.new("can't stub method on frozen object: #{mocha_inspect}", caller)
      end
      expectation = nil
      mockery = Mocha::Mockery.instance
      iterator = ArgumentIterator.new(expected_methods_vs_return_values)
      iterator.each { |*args|
        method_name = args.shift
        mockery.on_stubbing(self, method_name)
        method = stubba_method.new(stubba_object, method_name)
        mockery.stubba.stub(method)
        expectation = mocha.expects(method_name, caller)
        expectation.returns(args.shift) if args.length > 0
      }
      expectation
    end

    # Adds an expectation that the specified method may be called any number of times with any parameters.
    #
    # @param [Symbol,String] method_name name of stubbed method
    # @param [Hash] stubbed_methods_vs_return_values stubbed method name symbols as keys and corresponding return values as values - these stubbed methods are setup as if {#stubs} were called multiple times.
    #
    # @overload def stubs(method_name)
    # @overload def stubs(stubbed_methods_vs_return_values)
    # @return [Expectation] last-built expectation which can be further modified by methods on {Expectation}.
    # @raise [StubbingError] if attempting to stub method which is not allowed.
    #
    # @example Setting up a stubbed methods on a non-mock object.
    #   product = Product.new
    #   product.stubs(:save).returns(true)
    #   assert_equal true, product.save
    #
    # @example Setting up multiple stubbed methods on a non-mock object.
    #   product = Product.new
    #   product.stubs(:valid? => true, :save => true)
    #
    #   # exactly equivalent to
    #
    #   product = Product.new
    #   product.stubs(:valid?).returns(true)
    #   product.stubs(:save).returns(true)
    #
    # @see Mock#stubs
    def stubs(stubbed_methods_vs_return_values)
      if frozen?
        raise StubbingError.new("can't stub method on frozen object: #{mocha_inspect}", caller)
      end
      expectation = nil
      mockery = Mocha::Mockery.instance
      iterator = ArgumentIterator.new(stubbed_methods_vs_return_values)
      iterator.each { |*args|
        method_name = args.shift
        mockery.on_stubbing(self, method_name)
        method = stubba_method.new(stubba_object, method_name)
        mockery.stubba.stub(method)
        expectation = mocha.stubs(method_name, caller)
        expectation.returns(args.shift) if args.length > 0
      }
      expectation
    end

    # Removes the specified stubbed methods (added by calls to {#expects} or {#stubs}) and all expectations associated with them.
    #
    # Restores the original behaviour of the methods before they were stubbed.
    #
    # WARNING: If you {#unstub} a method which still has unsatisfied expectations, you may be removing the only way those expectations can be satisfied. Use {#unstub} with care.
    #
    # @param [Array<Symbol>] method_names names of methods to unstub.
    #
    # @example Stubbing and unstubbing a method on a real (non-mock) object.
    #   multiplier = Multiplier.new
    #   multiplier.double(2) # => 4
    #   multiplier.stubs(:double).raises # new behaviour defined
    #   multiplier.double(2) # => raises exception
    #   multiplier.unstub(:double) # original behaviour restored
    #   multiplier.double(2) # => 4
    #
    # @example Unstubbing multiple methods on a real (non-mock) object.
    #   multiplier.unstub(:double, :triple)
    #
    #   # exactly equivalent to
    #
    #   multiplier.unstub(:double)
    #   multiplier.unstub(:triple)
    def unstub(*method_names)
      mockery = Mocha::Mockery.instance
      method_names.each do |method_name|
        method = stubba_method.new(stubba_object, method_name)
        mockery.stubba.unstub(method)
      end
    end

    # @private
    def method_exists?(method, include_public_methods = true)
      if include_public_methods
        return true if public_methods(include_superclass_methods = true).include?(method)
        return true if respond_to?(method.to_sym)
      end
      return true if protected_methods(include_superclass_methods = true).include?(method)
      return true if private_methods(include_superclass_methods = true).include?(method)
      return false
    end

  end

  # @private
  module ModuleMethods

    def stubba_method
      Mocha::ModuleMethod
    end

  end

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

      def mocha
        @mocha ||= Mocha::Mockery.instance.mock_impersonating_any_instance_of(@stubba_object)
      end

      def stubba_method
        Mocha::AnyInstanceMethod
      end

      def stubba_object
        @stubba_object
      end

      def method_exists?(method, include_public_methods = true)
        if include_public_methods
          return true if @stubba_object.public_instance_methods(include_superclass_methods = true).include?(method)
        end
        return true if @stubba_object.protected_instance_methods(include_superclass_methods = true).include?(method)
        return true if @stubba_object.private_instance_methods(include_superclass_methods = true).include?(method)
        return false
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

# @private
class Object
  include Mocha::ObjectMethods
end

# @private
class Module
  include Mocha::ModuleMethods
end

# @private
class Class
  include Mocha::ClassMethods
end
