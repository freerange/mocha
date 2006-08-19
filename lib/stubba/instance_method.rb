require 'stubba/class_method'

module Stubba

  class InstanceMethod < ClassMethod
   
    def stub
      raise cannot_replace_method_error unless exists?
      define_new_method
    end
  
    def unstub
      # intentionally empty
    end
  
    def exists?
      stubbee.respond_to?(method)
    end
    
  end
  
end