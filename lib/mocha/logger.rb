# frozen_string_literal: true

module Mocha
  class Logger
    def initialize
      @io = $stderr
    end

    def warn(message)
      @io.puts "WARNING: #{message}"
    end
  end
end
