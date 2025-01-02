# frozen_string_literal: true

module Mocha
  class ImpersonatingName
    def initialize(object)
      @object = object
    end

    def mocha_inspect
      @object.mocha_inspect
    end
  end
end
