# frozen_string_literal: true

module Mocha
  class Logger
    def initialize(io)
      @io = io
    end

    def warn(message)
      @io.puts "WARNING: #{message}"
    end
  end
end
