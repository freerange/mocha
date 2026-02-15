# frozen_string_literal: true

module Mocha
  class Logger
    def warning(message)
      warn "WARNING: #{message}"
    end
  end
end
