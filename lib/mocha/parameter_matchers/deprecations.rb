require 'mocha/deprecation'
require 'set'

module Mocha
  module ParameterMatchers
    module Methods
      # @private
      def self.included(base)
        base.define_singleton_method(:const_missing) do |name|
          if ParameterMatchers.access_deprecated?(name)
            Mocha::ParameterMatchers.const_get(name).tap do |mod|
              Deprecation.warning(
                "Referencing #{name} outside its namespace is deprecated. Use fully-qualified #{mod} instead."
              )
            end
          else
            super(name)
          end
        end
      end
    end

    # @private
    @classes_with_access_deprecated = Set.new

    # @private
    def self.provide_deprecated_access_to(name)
      @classes_with_access_deprecated.add(name)
    end

    # @private
    def self.access_deprecated?(name)
      @classes_with_access_deprecated.include?(name)
    end

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
