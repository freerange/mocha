# frozen_string_literal: true

module Mocha
  class DefaultReceiver
    def initialize(mock)
      @mock = mock
    end

    def mocks
      [@mock]
    end
  end
end
