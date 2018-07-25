module Mocha
  class ArgumentIterator
    def initialize(argument)
      @argument = argument
    end

    def each
      if @argument.is_a?(Hash) then
        @argument.each do |method_name, return_value|
          yield method_name, return_value
        end
      else
        yield @argument
      end
    end
  end
end
