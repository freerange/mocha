module Mocha
  class Responder
    def initialize(&block)
      @block = block
    end

    def evaluate(*args)
      @block.call(*args)
    end
  end
end
