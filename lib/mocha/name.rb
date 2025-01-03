# frozen_string_literal: true

module Mocha
  class Name
    def initialize(name)
      @name = name.to_s
    end

    def mocha_inspect
      "#<Mock:#{@name}>"
    end
  end
end
