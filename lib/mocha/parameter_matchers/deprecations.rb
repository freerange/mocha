require 'mocha/deprecation'

module Mocha
  module ParameterMatchers
    # @private
    def self.define_deprecated_matcher_method(name)
      define_method(name) do |*args|
        Deprecation.warning(
          "Calling #{ParameterMatchers}##{name} is deprecated. Use #{Methods}##{name} instead."
        )
        Methods.instance_method(name).bind(self).call(*args)
      end
    end
  end
end
