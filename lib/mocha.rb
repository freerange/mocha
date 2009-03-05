require 'mocha_standalone'
require 'mocha/configuration'

if defined?(MiniTest::Unit::TestCase) && !MiniTest::Unit::TestCase.ancestors.include?(Mocha::API)
  require 'mocha/integration/mini_test'

  module MiniTest
    class Unit
      class TestCase
        
        include Mocha::API
        
        alias_method :run_before_mocha, :run
        remove_method :run
        
        include Mocha::Integration::MiniTest::Version131AndAbove
        
      end
    end
  end
end

if defined?(Bacon) && Bacon::VERSION >= "1.1" && defined?(Bacon::Context) && !Bacon::Context.ancestors.include?(Mocha::API)

  require 'mocha/integration/bacon'

  module Bacon
    class Context
      include Mocha::API
      include Mocha::Integration::Bacon::Version11AndAbove
    end
  end

end

require 'test/unit/testcase'
require 'mocha/integration/test_unit'

unless Test::Unit::TestCase.ancestors.include?(Mocha::API)
  module Test
    module Unit
      class TestCase
        
        include Mocha::API
        
        alias_method :run_before_mocha, :run
        remove_method :run
        
        test_unit_version = begin
          require 'test/unit/version'
          Test::Unit::VERSION
        rescue LoadError
          '1.x'
        end

        if test_unit_version == '2.0.0'
          include Mocha::Integration::TestUnit::GemVersion200
        elsif test_unit_version >= '2.0.1'
          include Mocha::Integration::TestUnit::GemVersion201AndAbove
        elsif RUBY_VERSION < '1.8.6'
          include Mocha::Integration::TestUnit::RubyVersion185AndBelow
        else
          include Mocha::Integration::TestUnit::RubyVersion186AndAbove
        end
        
      end
    end
  end
end
