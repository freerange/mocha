module Mocha
  class Thrower
    def initialize(tag, object = nil)
      @tag = tag
      @object = object
    end

    def evaluate(*_args)
      throw @tag, @object
    end
  end
end
