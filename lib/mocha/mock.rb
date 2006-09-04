require 'mocha/mock_methods'

module Mocha
  class Mock
  
    include MockMethods
    
    attr_reader :__mock_name
    def initialize(stub_everything = false, name = nil)
      @stub_everything = stub_everything
      @__mock_name = name
    end
    
    alias :mocha_inspect_before_hijacked_by_named_mocks :mocha_inspect
    def mocha_inspect
      @__mock_name ? "#<Mock: '#{@__mock_name}'>" : mocha_inspect_before_hijacked_by_named_mocks
    end
  
  end
end