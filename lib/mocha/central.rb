module Mocha

  class Central

    class Null < self

      def initialize(&block)
        super
        @raise_not_initialized_error = block
      end

      def stub(*)
        @raise_not_initialized_error.call
      end

      def unstub(*)
        @raise_not_initialized_error.call
      end

    end

    attr_accessor :stubba_methods

    def initialize
      self.stubba_methods = []
    end

    def stub(method)
      unless stubba_methods.detect { |m| m.matches?(method) }
        method.stub
        stubba_methods.push(method)
      end
    end

    def unstub(method)
      if existing = stubba_methods.detect { |m| m.matches?(method) }
        existing.unstub
        stubba_methods.delete(existing)
      end
    end

    def unstub_all
      while stubba_methods.any? do
        unstub(stubba_methods.first)
      end
    end

  end

end
