# frozen_string_literal: true

require 'mocha/api'

module Mocha
  module Integration
    module MonkeyPatcher
      def self.apply(mod, run_method_patch)
        if mod < Mocha::API
          warn "Mocha::API already included in #{mod}" if $DEBUG
        else
          mod.send(:include, Mocha::API)
        end
        if mod.method_defined?(:run_before_mocha)
          warn "#{mod}#run_before_mocha method already defined" if $DEBUG
        elsif mod.method_defined?(:run)
          mod.send(:alias_method, :run_before_mocha, :run)
          mod.send(:remove_method, :run)
          mod.send(:include, run_method_patch)
        else
          raise "Unable to monkey-patch #{mod}, because it does not define a `#run` method"
        end
      end
    end
  end
end
