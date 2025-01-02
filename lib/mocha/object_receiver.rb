# frozen_string_literal: true

module Mocha
  class ObjectReceiver
    def initialize(object)
      @object = object
    end

    def mocks
      object = @object
      mocks = []
      while object
        mocha = object.mocha(instantiate: false)
        mocks << mocha if mocha
        object = object.is_a?(Class) ? object.superclass : nil
      end
      mocks
    end
  end
end
