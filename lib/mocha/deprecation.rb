# frozen_string_literal: true

require 'mocha/logger'

module Mocha
  class Deprecation
    class << self
      def warning(message)
        Logger.warning(message, category: :deprecation)
      end
    end
  end
end
