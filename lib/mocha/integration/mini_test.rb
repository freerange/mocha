require 'mocha/api'
require 'mocha/options'

if !MiniTest::Unit::TestCase.ancestors.include?(Mocha::API)

  require 'mocha/integration/mini_test/exception_translation'
  require 'mocha/integration/mini_test/version_13'
  require 'mocha/integration/mini_test/version_140'
  require 'mocha/integration/mini_test/version_141'
  require 'mocha/integration/mini_test/version_142_to_172'
  require 'mocha/integration/mini_test/version_200'
  require 'mocha/integration/mini_test/version_201_to_222'
  require 'mocha/integration/mini_test/version_230_to_262'

  module MiniTest
    class Unit
      class TestCase

        include Mocha::API

        alias_method :run_before_mocha, :run
        remove_method :run

        mini_test_version = begin
          Gem::Version.new(MiniTest::Unit::VERSION)
        rescue LoadError
          Gem::Version.new('0.0.0')
        end

        $stderr.puts "Detected MiniTest version: #{mini_test_version}" if $mocha_options['debug']

        if Gem::Requirement.new('>= 1.3.0', '<= 1.3.1').satisfied_by?(mini_test_version)
          include Mocha::Integration::MiniTest::Version13
        elsif Gem::Requirement.new('1.4.0').satisfied_by?(mini_test_version)
          include Mocha::Integration::MiniTest::Version140
        elsif Gem::Requirement.new('1.4.1').satisfied_by?(mini_test_version)
          include Mocha::Integration::MiniTest::Version141
        elsif Gem::Requirement.new('>= 1.4.2', '<= 1.7.2').satisfied_by?(mini_test_version)
          include Mocha::Integration::MiniTest::Version142To172
        elsif Gem::Requirement.new('2.0.0').satisfied_by?(mini_test_version)
          include Mocha::Integration::MiniTest::Version200
        elsif Gem::Requirement.new('>= 2.0.1', '<= 2.2.2').satisfied_by?(mini_test_version)
          include Mocha::Integration::MiniTest::Version201To222
        elsif Gem::Requirement.new('>= 2.3.0').satisfied_by?(mini_test_version)
          $stderr.puts "*** MiniTest integration has not been verified but patching anyway ***" if (Gem::Requirement.new('> 2.6.2').satisfied_by?(mini_test_version)) && $mocha_options['debug']
          include Mocha::Integration::MiniTest::Version230To262
        else
          $stderr.puts "*** No Mocha integration for MiniTest version ***" if $mocha_options['debug']
        end

      end
    end
  end
end
