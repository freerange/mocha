module Mocha # :nodoc:
  
  class YieldParameters # :nodoc:
    
    def initialize
      @parameter_groups = []
    end
    
    def next
      case @parameter_groups.size
      when 0, 1: @parameter_groups.first
      else @parameter_groups.shift
      end
    end
    
    def add(*parameters)
      @parameter_groups << parameters
    end
    
  end
  
end