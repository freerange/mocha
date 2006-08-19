require 'mocha/metaclass'

module Stubba

  class ClassMethod
  
    attr_reader :stubbee, :method
   
    def initialize(stubbee, method)
      @stubbee, @method = stubbee, method
    end
  
    def stub
      hide_original_method
      define_new_method
    end
  
    def unstub
      remove_new_method
      restore_original_method
      stubbee.reset_mocha
    end
    
    def mock
      stubbee.mocha
    end
  
    def hide_original_method
      stubbee.metaclass.class_eval "alias_method :#{hidden_method}, :#{method}" if stubbee.metaclass.method_defined?(method)
    end
  
    def define_new_method
      stubbee.metaclass.class_eval "def #{method}(*args, &block); mocha.method_missing(:#{method}, *args, &block); end"
    end
  
    def remove_new_method
      stubbee.metaclass.class_eval "remove_method :#{method}"
    end
  
    def restore_original_method
      stubbee.metaclass.class_eval "alias_method :#{method}, :#{hidden_method}; remove_method :#{hidden_method}" if stubbee.metaclass.method_defined?(hidden_method)
    end
  
    def hidden_method
      "__stubba__#{method.to_s.sub('!', '_exclamation_mark').sub('?', '_question_mark')}__stubba__"
    end  
  
    def cannot_replace_method_error
      Test::Unit::AssertionFailedError.new("Cannot replace #{method} because it is not defined in #{stubbee}.")
    end
  
    def eql?(other)
      return false unless (other.class == self.class)
      (stubbee == other.stubbee) and (method == other.method)
    end
  
    alias_method :==, :eql?
  
    def to_s
      "#{stubbee}.#{method}"
    end

  end
  
end