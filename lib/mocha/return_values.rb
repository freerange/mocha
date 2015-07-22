require 'mocha/single_return_value'

module Mocha

  class ReturnValues

    def self.build(*values, &result_block)
      values << result_block if block_given?
      new(*values.map { |value| SingleReturnValue.new(value) })
    end

    attr_accessor :values, :result_block

    def initialize(*values)
      @values = values
    end

    def next(*actual_parameters)
      case @values.length
        when 0 then nil
        when 1 then @values.first.evaluate(*actual_parameters)
        else @values.shift.evaluate(*actual_parameters)
      end
    end

    def +(other)
      self.class.new(*(@values + other.values))
    end

  end

end
