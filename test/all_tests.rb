require 'test_helper'
require 'stubba/test_case' # only works if loaded before any derived test cases

require 'test/unit/ui/console/testrunner'

require 'inspect_test'
require 'pretty_parameters_test'

class SupportUnitTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('SupportUnitTests')
    suite << MochaInspectTest.suite
    suite << PrettyParametersTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(SupportUnitTests)

require 'auto_mock_test'
require 'expectation_test'
require 'infinite_range_test'
require 'mock_methods_test'
require 'mock_class_test'
require 'mock_test'

class MochaUnitTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('MochaUnitTests')
    suite << AutoMockTest.suite
    suite << ExpectationTest.suite
    suite << InfiniteRangeTest.suite
    suite << MockMethodsTest.suite
    suite << MockClassTest.suite
    suite << MockTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(MochaUnitTests)

require 'stubba_test'
require 'stubba_class_method_test'
require 'stubba_instance_method_test'
require 'stubba_any_instance_method_test'
require 'stubba_test_case_test'

class StubbaUnitTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('StubbaUnitTests')
    suite << StubbaTest.suite
    suite << ClassMethodTest.suite
    suite << InstanceMethodTest.suite
    suite << AnyInstanceMethodTest.suite
    suite << StubbaTestCaseTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(StubbaUnitTests)

require 'stubba_object_test'

class IsolatedStubbaUnitTests # avoid loading stubba_object until now which breaks other stubba unit tests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('IsolatedStubbaUnitTests')
    suite << StubbaObjectTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(IsolatedStubbaUnitTests)

require 'stubba_integration_test'
Test::Unit::UI::Console::TestRunner.run(StubbaIntegrationTest)

require 'mock_acceptance_test'
require 'stubba_acceptance_test'
require 'auto_mock_acceptance_test'

class AcceptanceTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('AcceptanceTests')
    suite << MockAcceptanceTest.suite
    suite << StubbaAcceptanceTest.suite
    suite << AutoMockAcceptanceTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(AcceptanceTests)