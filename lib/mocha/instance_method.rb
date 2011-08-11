require 'mocha/class_method'

module Mocha

  class InstanceMethod < ClassMethod

    def hide_original_method
      super if singleton_method?(method)
    end

    def restore_original_method
      super if singleton_method?(hidden_method)
    end

    def method_exists?(method)
      return true if stubbee.public_methods(false).include?(method)
      return true if stubbee.protected_methods(false).include?(method)
      return true if stubbee.private_methods(false).include?(method)
      return false
    end

    def singleton_method?(method)
      __metaclass__ = stubbee.__metaclass__
      return true if __metaclass__.public_instance_methods(false).include?(method)
      return true if __metaclass__.protected_instance_methods(false).include?(method)
      return true if __metaclass__.private_instance_methods(false).include?(method)
      return false
    end

  end

end