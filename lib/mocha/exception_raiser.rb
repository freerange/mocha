module Mocha
  class ExceptionRaiser
    def initialize(exception, message)
      @exception = exception
      @message = message
    end

    def evaluate
      fail @exception, @exception.to_s if @exception.is_a?(Module) && (@exception < Interrupt)
      fail @exception, @message if @message
      fail @exception
    end
  end
end
