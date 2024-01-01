require 'mocha/stubbed_method'

module Mocha
  class AnyInstanceMethod < StubbedMethod
    def initialize(stubbee, method_name)
      super(stubbee, stubbee.any_instance, stubbee, method_name)
    end
  end
end
