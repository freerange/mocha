require 'mocha/api'
require 'mocha/options'

if !Test::Unit::TestCase.ancestors.include?(Mocha::API)

  require 'mocha/monkey_patching/test_unit/gem_version_200'
  require 'mocha/monkey_patching/test_unit/gem_version_201_to_202'
  require 'mocha/monkey_patching/test_unit/gem_version_203_to_220'
  require 'mocha/monkey_patching/test_unit/gem_version_230_to_251'
  require 'mocha/monkey_patching/test_unit/ruby_version_185_and_below'
  require 'mocha/monkey_patching/test_unit/ruby_version_186_and_above'

  module Test
    module Unit
      class TestCase

        include Mocha::API

        alias_method :run_before_mocha, :run
        remove_method :run

        test_unit_version = begin
          load 'test/unit/version.rb'
          Gem::Version.new(Test::Unit::VERSION)
        rescue LoadError
          Gem::Version.new('1.x')
        end

        if $mocha_options['debug']
          $stderr.puts "Detected Ruby version: #{RUBY_VERSION}"
          $stderr.puts "Detected Test::Unit version: #{test_unit_version}"
        end

        if (test_unit_version == Gem::Version.new('1.x')) || (test_unit_version == Gem::Version.new('1.2.3'))
          if RUBY_VERSION < '1.8.6'
            include Mocha::MonkeyPatching::TestUnit::RubyVersion185AndBelow
          else
            include Mocha::MonkeyPatching::TestUnit::RubyVersion186AndAbove
          end
        elsif Gem::Requirement.new('2.0.0').satisfied_by?(test_unit_version)
          include Mocha::MonkeyPatching::TestUnit::GemVersion200
        elsif Gem::Requirement.new('>= 2.0.1', '<= 2.0.2').satisfied_by?(test_unit_version)
          include Mocha::MonkeyPatching::TestUnit::GemVersion201To202
        elsif Gem::Requirement.new('>= 2.0.3', '<= 2.2.0').satisfied_by?(test_unit_version)
          include Mocha::MonkeyPatching::TestUnit::GemVersion203To220
        elsif Gem::Requirement.new('>= 2.3.0', '<= 2.5.1').satisfied_by?(test_unit_version)
          include Mocha::MonkeyPatching::TestUnit::GemVersion230To251
        else
          $stderr.puts "*** No Mocha monkey-patch for Test::Unit version ***" if $mocha_options['debug']
        end

      end
    end
  end

end
