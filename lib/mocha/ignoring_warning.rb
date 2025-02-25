module Mocha
  # @private
  module IgnoringWarning
    def ignoring_warning(pattern, if_: true)
      return yield unless if_

      begin
        original_warn = Warning.method(:warn)
        Warning.singleton_class.define_method(:warn) do |message|
          original_warn.call(message) unless message =~ pattern
        end

        yield
      ensure
        Warning.singleton_class.undef_method(:warn)
        Warning.singleton_class.define_method(:warn, original_warn)
      end
    end
  end
end
