require 'mocha/module_method'

module Mocha

  class ModuleMethod < ClassMethod

    def method_exists?(method)
      existing_methods = []
      existing_methods += stubbee.public_methods(false)
      existing_methods += stubbee.protected_methods(false)
      existing_methods += stubbee.private_methods(false)
      existing_methods.any? { |m| m.to_s == method.to_s }
    end

  end
  
end