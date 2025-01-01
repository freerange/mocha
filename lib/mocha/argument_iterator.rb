# frozen_string_literal: true

module Mocha
  class ArgumentIterator
    def initialize(argument)
      @argument = argument
    end

    def each(&block)
      if @argument.is_a?(Hash)
        @argument.each(&block)
      else
        block.call(@argument)
      end
    end
  end
end
