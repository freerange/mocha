require 'mocha/single_return_value'
require 'mocha/single_return_block'

module Mocha # :nodoc:
  
  class ReturnValues # :nodoc:
    
    def self.build(*values,&blk)
      values.map! { |value| SingleReturnValue.new(value) }
      values << SingleReturnBlock.new(blk) if blk
      new(*values)
    end
    
    attr_accessor :values
    
    def initialize(*values)
      @values = values
    end
    
    def next(*arguments)
      case @values.length
        when 0 then nil
        when 1 then @values.first.evaluate(*arguments)
        else @values.shift.evaluate(*arguments)
      end
    end
    
    def +(other)
      self.class.new(*(@values + other.values))
    end
    
  end
  
end