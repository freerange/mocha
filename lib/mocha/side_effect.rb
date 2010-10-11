module Mocha

  class SideEffect
  
    def initialize(&proc)
      @effect = proc
    end
  
    def perform
      @effect.call
    end
  
    def mocha_inspect
      "then #{@effect.mocha_inspect}"
    end
  
  end

end