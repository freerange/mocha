# frozen_string_literal: true

module Mocha
  class DefaultName
    def initialize(mock)
      @mock = mock
    end

    def mocha_inspect
      address = @mock.__id__ * 2
      address += 0x100000000 if address < 0
      "#<Mock:0x#{format('%<address>x', address: address)}>"
    end
  end
end
