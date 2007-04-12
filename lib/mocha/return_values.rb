require 'mocha/single_return_value'

module Mocha # :nodoc:
  
  class ReturnValues # :nodoc:
    
    def self.build(*values)
      ReturnValues.new(*values.map { |value| SingleReturnValue.new(value) })
    end
    
    attr_accessor :values
    
    def initialize(*values)
      @values = values
    end
    
    def next
      case @values.size
      when 0: nil
      when 1: @values.first.evaluate
      else @values.shift.evaluate
      end
    end
    
    def +(other)
      ReturnValues.new(*(@values + other.values))
    end
    
  end
  
end