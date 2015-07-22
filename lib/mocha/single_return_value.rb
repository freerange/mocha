require 'mocha/is_a'

module Mocha

  class SingleReturnValue

    def initialize(value)
      @value = value
    end

    def evaluate(*args)
      @value.respond_to?(:call) ? @value.call(*args) : @value
    end

  end

end
