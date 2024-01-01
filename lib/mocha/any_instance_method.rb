require 'mocha/stubbed_method'

module Mocha
  class AnyInstanceMethod < StubbedMethod
    private

    def mock_owner
      stubbee.any_instance
    end

    def original_method_owner
      stubbee
    end
  end
end
