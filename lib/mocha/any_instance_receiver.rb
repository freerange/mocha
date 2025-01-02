# frozen_string_literal: true

module Mocha
  class AnyInstanceReceiver
    def initialize(klass)
      @klass = klass
    end

    def mocks
      klass = @klass
      mocks = []
      while klass
        mocha = klass.any_instance.mocha(instantiate: false)
        mocks << mocha if mocha
        klass = klass.superclass
      end
      mocks
    end
  end
end
