module Mocha
  class ArgumentIterator
    def self.each(argument)
      if argument.is_a?(Hash)
        argument.each do |method_name, return_value|
          yield method_name, return_value
        end
      else
        yield argument
      end
    end
  end
end
