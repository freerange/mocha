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
      metaclass = stubbee.metaclass
      return true if metaclass.public_instance_methods(false).include?(method)
      return true if metaclass.protected_instance_methods(false).include?(method)
      return true if metaclass.private_instance_methods(false).include?(method)
      return false
    end

  end

end