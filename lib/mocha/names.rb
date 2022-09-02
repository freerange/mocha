module Mocha
  class ImpersonatingName
    def initialize(object)
      @object = object
    end

    def mocha_inspect
      @object.mocha_inspect
    end
  end

  class ImpersonatingAnyInstanceName
    def initialize(klass)
      @klass = klass
    end

    def mocha_inspect
      "#<AnyInstance:#{@klass.mocha_inspect}>"
    end
  end

  class Name
    def initialize(name)
      @name = name.to_s
    end

    def mocha_inspect
      "#<Mock:#{@name}>"
    end
  end

  class DefaultName
    def initialize(mock)
      @mock = mock
    end

    def mocha_inspect
      Inspect.describe(@mock)
    end
  end
end
