# frozen_string_literal: true

module Mocha
  class Logger
    def initialize(io)
      @io = io
    end

    def warn(message, location = nil)
      output = "WARNING: #{message}"
      output += " at #{location}" if location
      @io.puts output
    end
  end
end
