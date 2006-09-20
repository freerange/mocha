require 'mocha/mock_methods'

module Mocha
  
  module ExtraMethods

    attr_reader :__mock_name
    def initialize(stub_everything = false, name = nil)
      @stub_everything = stub_everything
      @__mock_name = name
    end
    
    alias :mocha_inspect_before_hijacked_by_named_mocks :mocha_inspect
    def mocha_inspect
      @__mock_name ? "#<Mock:#{@__mock_name}>" : mocha_inspect_before_hijacked_by_named_mocks
    end
    
  end
  
  class Mock
    
    include MockMethods
    include ExtraMethods
    
  end
  
  class BlankMock

    methods_to_keep = /^__.*__$|respond_to?|mocha_inspect|inspect|class|object_id|send|is_a\?|==|hash|nil\?|extend|eql\?/
    instance_methods.each { |method_to_remove| eval("undef :#{method_to_remove}") unless method_to_remove =~ methods_to_keep }
  
    include MockMethods
    include ExtraMethods

  end
  
end