require 'mocha/mock_methods'

module Mocha
  class Mock
  
    include MockMethods
  
    def initialize(stub_everything = false)
      @stub_everything = stub_everything
    end
  
  end
end