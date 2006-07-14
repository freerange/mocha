require 'mocha/stubba_class_method'

class StubbaInstanceMethod < StubbaClassMethod
   
  def stub
    raise cannot_replace_method_error unless exists?
    define_new_method
  end
  
  def unstub
    # intentionally empty
  end
  
  def exists?
    object.respond_to?(method)
  end
    
end