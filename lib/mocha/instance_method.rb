# frozen_string_literal: true

require 'mocha/stubbed_method'

module Mocha
  class InstanceMethod < StubbedMethod
    private

    def stubbee
      stubba_object
    end

    def original_method_owner
      stubba_object.singleton_class
    end
  end
end
