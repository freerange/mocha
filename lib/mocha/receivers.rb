module Mocha
  class StubbedReceiver
    def initialize(object)
      @object = object
    end

    def mocks
      object = @object
      mocks = []
      while object
        mocha = stubbee(object).mocha(false)
        mocks << mocha if mocha
        object = object.is_a?(Class) ? object.superclass : nil
      end
      mocks
    end
  end

  class InstanceReceiver < StubbedReceiver
    def stubbee(object)
      object
    end
  end

  class AnyInstanceReceiver < StubbedReceiver
    def stubbee(klass)
      klass.any_instance
    end
  end

  class DefaultReceiver
    def initialize(mock)
      @mock = mock
    end

    def mocks
      [@mock]
    end
  end
end
