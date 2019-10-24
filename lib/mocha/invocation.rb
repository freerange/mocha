require 'mocha/raised_exception'

module Mocha
  class Invocation
    def initialize(return_values)
      @return_values = return_values
    end

    def call
      @result = @return_values.next
    rescue Exception => e # rubocop:disable Lint/RescueException
      @result = RaisedException.new(e)
      raise
    end

    def mocha_inspect
      @result.mocha_inspect
    end
  end
end
