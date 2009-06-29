require 'mocha/api'

if !Test::Unit::TestCase.ancestors.include?(Mocha::API)
 
  require 'mocha/integration/test_unit/gem_version_200'
  require 'mocha/integration/test_unit/gem_version_201_and_above'
  require 'mocha/integration/test_unit/ruby_version_185_and_below'
  require 'mocha/integration/test_unit/ruby_version_186_and_above'
  
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