require 'mocha'
require 'stubba_instance_method'
require 'stubba_class_method'
require 'stubba_any_instance_method'

class Object
  
  def mocha
    @mocha ||= Mocha.new
  end
  
  def reset_mocha
    @mocha = nil
  end
  
  def stubba_method
    StubbaInstanceMethod
  end
  
  def stubba_object
    self
  end

  def expects(symbol) 
    method = stubba_method.new(stubba_object, symbol)
    $stubba.stub(method)
    mocha.expects(symbol)
  end
  
  def stubs(symbol) 
    method = stubba_method.new(stubba_object, symbol)
    $stubba.stub(method)
    mocha.stubs(symbol)
  end
  
  def verify(*method_names)
    mocha.verify(*method_names)
  end
  
end

class Module
  
  def stubba_method
    StubbaClassMethod
  end
    
end
  
class Class
  
  def stubba_method
    StubbaClassMethod
  end

  class AnyInstance
    
    def initialize(klass)
      @stubba_object = klass
    end
    
    def stubba_method
      StubbaAnyInstanceMethod
    end
    
    def stubba_object
      @stubba_object
    end
    
  end
  
  def any_instance
    @any_instance ||= AnyInstance.new(self)
  end
  
end

