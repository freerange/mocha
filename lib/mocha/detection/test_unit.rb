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
          rescue LoadError
          end
          version = ::Test::Unit::VERSION if defined?(::Test::Unit::VERSION)
        end
        version
      end
    end
  end
end
