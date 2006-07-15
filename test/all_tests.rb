require 'test_helper'
require 'stubba/test_case' # only works if loaded before any derived test cases

require 'test/unit/ui/console/testrunner'

require 'mocha/inspect_test'
require 'mocha/pretty_parameters_test'
require 'mocha/expectation_test'
require 'mocha/infinite_range_test'
require 'mocha/mock_methods_test'
require 'mocha/mock_test'

class MochaUnitTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('MochaUnitTests')
    suite << InspectTest.suite
    suite << PrettyParametersTest.suite
    suite << ExpectationTest.suite
    suite << InfiniteRangeTest.suite
    suite << MockMethodsTest.suite
    suite << MockTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(MochaUnitTests)

require 'auto_mocha/mock_class_test'
require 'auto_mocha/auto_mock_test'

class AutoMochaUnitTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('AutoMochaUnitTests')
    suite << AutoMockTest.suite
    suite << MockClassTest.suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(AutoMochaUnitTests)

require 'stubba/stubba_test'
require 'stubba/class_method_test'
require 'stubba/instance_method_test'
require 'stubba/any_instance_method_test'
require 'stubba/test_case_test'

class StubbaUnitTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('StubbaUnitTests')
    suite << StubbaTest.suite
    suite << ClassMethodTest.suite
    suite << InstanceMethodTest.suite
    suite << AnyInstanceMethodTest.suite
    suite << TestCaseTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(StubbaUnitTests)

require 'stubba/object_test'

class IsolatedStubbaUnitTests # avoid loading stubba_object until now which breaks other stubba unit tests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('IsolatedStubbaUnitTests')
    suite << ObjectTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(IsolatedStubbaUnitTests)

require 'stubba_integration_test'
Test::Unit::UI::Console::TestRunner.run(StubbaIntegrationTest)

require 'mocha_acceptance_test'
require 'stubba_acceptance_test'
require 'auto_mock_acceptance_test'

class AcceptanceTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('AcceptanceTests')
    suite << MochaAcceptanceTest.suite
    suite << StubbaAcceptanceTest.suite
    suite << AutoMockAcceptanceTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(AcceptanceTests)