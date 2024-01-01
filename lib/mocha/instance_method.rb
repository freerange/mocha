require 'mocha/stubbed_method'

module Mocha
  class InstanceMethod < StubbedMethod
    def initialize(stubbee, method_name)
      super(stubbee, stubbee, stubbee.singleton_class, method_name)
    end
  end
end
