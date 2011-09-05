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
  require 'mocha/integration/mini_test/version_230_to_251'

  module MiniTest
    class Unit
      class TestCase

        include Mocha::API

        alias_method :run_before_mocha, :run
        remove_method :run

        mini_test_version = begin
          MiniTest::Unit::VERSION
        rescue LoadError
          'unknown'
        end

        $stderr.puts "Detected MiniTest version: #{mini_test_version}" if $options['debug']

        if (mini_test_version >= '1.3.0') && (mini_test_version <= '1.3.1')
          include Mocha::Integration::MiniTest::Version13
        elsif (mini_test_version == '1.4.0')
          include Mocha::Integration::MiniTest::Version140
        elsif (mini_test_version == '1.4.1')
          include Mocha::Integration::MiniTest::Version141
        elsif (mini_test_version >= '1.4.2') && (mini_test_version <= '1.7.2')
          include Mocha::Integration::MiniTest::Version142To172
        elsif (mini_test_version == '2.0.0')
          include Mocha::Integration::MiniTest::Version200
        elsif (mini_test_version >= '2.0.1') && (mini_test_version <= '2.2.2')
          include Mocha::Integration::MiniTest::Version201To222
        elsif (mini_test_version >= '2.3.0') && (mini_test_version <= '2.5.1')
          include Mocha::Integration::MiniTest::Version230To251
        elsif (mini_test_version > '2.5.1')
          $stderr.puts "*** MiniTest integration has not been verified but patching anyway ***" if $options['debug']
          include Mocha::Integration::MiniTest::Version230To251
        else
          $stderr.puts "*** No Mocha integration for MiniTest version ***" if $options['debug']
        end

      end
    end
  end
end
