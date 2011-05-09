require 'mocha/class_method'

module Mocha

  class InstanceMethod < ClassMethod

    def hide_original_method
      # intentionally left blank
    end

    def restore_original_method
      # intentionally left blank
    end

    def method_exists?(method)
      return true if stubbee.public_methods(false).include?(method)
      return true if stubbee.protected_methods(false).include?(method)
      return true if stubbee.private_methods(false).include?(method)
      return false
    end

  end
  
end