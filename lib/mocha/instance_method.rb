require 'mocha/class_method'

module Mocha

  class InstanceMethod < ClassMethod

    def hide_original_method
      if stubbee.singleton_methods(false).include?(method)
        super
      end
    end

    def restore_original_method
      if stubbee.singleton_methods(false).include?(hidden_method)
        super
      end
    end

    def method_exists?(method)
      return true if stubbee.public_methods(false).include?(method)
      return true if stubbee.protected_methods(false).include?(method)
      return true if stubbee.private_methods(false).include?(method)
      return false
    end

  end
  
end