module Stub
  
  class Matcher

    attr_accessor :value

    def initialize(matches)
      @matches = matches
    end

    def ==(value)
      @value = value
      @matches
    end

    def mocha_inspect
      "matcher(#{@matches})"
    end

  end
  
end