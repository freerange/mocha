require 'mocha/ruby_version'
require 'mocha/class_method'

module Mocha
  class AnyInstanceMethod < ClassMethod
    def mock
      stubbee.any_instance.mocha
    end

    def reset_mocha
      stubbee.any_instance.reset_mocha
    end

    private

    def stub_method_definition(method_name)
      proc do |*args, &block|
        self.class.any_instance.mocha.method_missing(method_name, *args, &block)
      end
    end

    def original_method_owner
      stubbee
    end
  end
end
