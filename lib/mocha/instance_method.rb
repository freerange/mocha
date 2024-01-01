require 'mocha/stubbed_method'

module Mocha
  class InstanceMethod < StubbedMethod
    private

    def mock_owner
      stubbee
    end

    def original_method_owner
      stubbee.singleton_class
    end
  end
end
