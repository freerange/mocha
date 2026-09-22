# frozen_string_literal: true

require 'mocha/stubbed_method'

module Mocha
  class AnyInstanceMethod < StubbedMethod
    private

    def stubbee
      stubba_object.any_instance
    end

    def original_method_owner
      stubba_object
    end
  end
end
