module Mocha
  class ArgumentIterator
    def self.each(argument)
      Array(argument).map { |*args| yield *(args.flatten) }.last
    end
  end
end
