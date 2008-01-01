require 'mocha/expectation'
require 'mocha/cardinality'

module Mocha # :nodoc:

  class Stub < Expectation # :nodoc:

    def initialize(mock, method_name, backtrace = nil)
      super
      @cardinality = Cardinality.at_least(0)
    end
    
    def verify
      true
    end

  end

end