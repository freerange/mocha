require 'mocha/is_a'

module Mocha
  class SingleReturnValue
    def initialize(value)
      @value = value
    end

    def evaluate(*_args)
      @value
    end
  end
end
