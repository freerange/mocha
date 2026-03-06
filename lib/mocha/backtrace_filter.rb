# frozen_string_literal: true

module Mocha
  class BacktraceFilter
    LIB_DIRECTORY = File.expand_path(File.join(File.dirname(__FILE__), '..')) + File::SEPARATOR

    def initialize(lib_directory = LIB_DIRECTORY)
      @lib_directory = lib_directory
    end

    def filtered(backtrace)
      backtrace.reject { |line| exclude?(line) }
    end

    private

    def exclude?(path)
      File.expand_path(path).start_with?(@lib_directory)
    end
  end
end
