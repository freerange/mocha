require 'mocha/single_yield_parameter_group'
require 'mocha/null_yield_parameter_group'
require 'mocha/multiple_yield_parameter_group'

module Mocha # :nodoc:
  
  class YieldParameters # :nodoc:
    
    def initialize
      @parameter_groups = []
    end
    
    def next_invocation
      case @parameter_groups.size
      when 0: NullYieldParameterGroup.new
      when 1: @parameter_groups.first
      else @parameter_groups.shift
      end
    end
    
    def add(*parameters)
      @parameter_groups << SingleYieldParameterGroup.new(*parameters)
    end
    
    def multiple_add(*parameter_groups)
      @parameter_groups << MultipleYieldParameterGroup.new(*parameter_groups)
    end
    
  end
  
end