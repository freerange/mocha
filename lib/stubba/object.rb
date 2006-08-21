require 'mocha/mock'
require 'stubba/instance_method'
require 'stubba/class_method'
require 'stubba/any_instance_method'

class Object
  
  def mocha
    @mocha ||= Mocha::Mock.new
  end
  
  def reset_mocha
    @mocha = nil
  end
  
  def stubba_method
    Stubba::InstanceMethod
  end
  
  def stubba_object
    self
  end

  def expects(symbol) 
    method = stubba_method.new(stubba_object, symbol)
    $stubba.stub(method)
    mocha.expects(symbol, caller)
  end
  
  def stubs(symbol) 
    method = stubba_method.new(stubba_object, symbol)
    $stubba.stub(method)
    mocha.stubs(symbol, caller)
  end
  
  def verify
    mocha.verify
  end
  
end

class Module
  
  def stubba_method
    Stubba::ClassMethod
  end
    
end
  
class Class
  
  def stubba_method
    Stubba::ClassMethod
  end

  class AnyInstance
    
    def initialize(klass)
      @stubba_object = klass
    end
    
    def stubba_method
      Stubba::AnyInstanceMethod
    end
    
    def stubba_object
      @stubba_object
    end
    
  end
  
  def any_instance
    @any_instance ||= AnyInstance.new(self)
  end
  
end

