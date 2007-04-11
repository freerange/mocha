require 'mocha/expectation'

module Mocha # :nodoc:

  class Stub < Expectation # :nodoc:

    def verify
      true
    end

  end

end