# frozen_string_literal: true

module Mocha
  class ImpersonatingAnyInstanceName
    def initialize(klass)
      @klass = klass
    end

    def mocha_inspect
      "#<AnyInstance:#{@klass.mocha_inspect}>"
    end
  end
end
