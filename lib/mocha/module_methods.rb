require 'mocha/instance_method'

module Mocha
  # @private
  module ModuleMethods
    def stubba_method
      Mocha::InstanceMethod
    end
  end
end
