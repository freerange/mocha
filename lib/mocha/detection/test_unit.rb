module Mocha
  module Detection
    module TestUnit
      def self.testcase
        if defined?(::Test::Unit::TestCase) &&
           !(defined?(::MiniTest::Unit::TestCase) && (::Test::Unit::TestCase < ::MiniTest::Unit::TestCase)) &&
           !(defined?(::MiniTest::Spec) && (::Test::Unit::TestCase < ::MiniTest::Spec))
          ::Test::Unit::TestCase
        end
      end

      def self.version
        version = '1.0.0'
        if testcase
          begin
            require 'test/unit/version'
          # rubocop:disable Lint/HandleExceptions
          rescue LoadError
          end
          # rubocop:enable Lint/HandleExceptions
          if defined?(::Test::Unit::VERSION)
            version = ::Test::Unit::VERSION
          end
        end
        version
      end
    end
  end
end
