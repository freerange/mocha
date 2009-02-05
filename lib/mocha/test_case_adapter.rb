require 'mocha/test_unit_gem_version_200_monkey_patch'
require 'mocha/test_unit_gem_version_201_and_above_monkey_patch'
require 'mocha/ruby_version_185_and_below_monkey_patch'
require 'mocha/ruby_version_186_and_above_monkey_patch'

module Mocha
  
  module TestCaseAdapter
    
    def self.included(base)
      base.send(:alias_method, :run_before_mocha_test_case_adapter, :run)
      base.send(:remove_method, :run)
      if Mocha.test_unit_version == '2.0.0'
        base.send(:include, TestUnitGem::Version200::MonkeyPatch)
      elsif Mocha.test_unit_version >= '2.0.1'
        base.send(:include, TestUnitGem::Version201AndAbove::MonkeyPatch)
      elsif RUBY_VERSION < '1.8.6'
        base.send(:include, Ruby::Version185AndBelow::MonkeyPatch)
      else
        base.send(:include, Ruby::Version186AndAbove::MonkeyPatch)
      end
    end
    
  end
  
  private
  
  def self.test_unit_version
    require 'test/unit/version'
    Test::Unit::VERSION
  rescue LoadError
    '1.x'
  end

end