module Mocha
  class Thrower
    def initialize(tag, object = nil)
      @tag = tag
      @object = object
    end

    def evaluate
      throw @tag, @object
    end
  end
end
