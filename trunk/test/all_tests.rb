require 'test/unit/ui/console/testrunner'

require 'mocha/inspect_test'
require 'mocha/pretty_parameters_test'
require 'mocha/expectation_test'
require 'mocha/infinite_range_test'
require 'mocha/mock_methods_test'
require 'mocha/mock_test'
require 'mocha/auto_verify_test'

require 'mocha/central_test'
require 'mocha/class_method_test'
require 'mocha/any_instance_method_test'
require 'mocha/setup_and_teardown_test'
require 'mocha/object_test'
require 'mocha/metaclass_test'

class UnitTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('UnitTests')
    suite << InspectTest.suite
    suite << PrettyParametersTest.suite
    suite << ExpectationTest.suite
    suite << InfiniteRangeTest.suite
    suite << MockMethodsTest.suite
    suite << MockTest.suite
    suite << AutoVerifyTest.suite
    suite << CentralTest.suite
    suite << ClassMethodTest.suite
    suite << AnyInstanceMethodTest.suite
    suite << SetupAndTeardownTest.suite
    suite << ObjectTest.suite
    suite << MetaclassTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(UnitTests)

require 'mocha_test_result_integration_test'
require 'stubba_test_result_integration_test'
require 'stubba_integration_test'

class IntegrationTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('IntegrationTests')
    suite << MochaTestResultIntegrationTest.suite
    suite << StubbaTestResultIntegrationTest.suite
    suite << StubbaIntegrationTest.suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(IntegrationTests)

require 'mocha_acceptance_test'
require 'stubba_acceptance_test'
require 'standalone_acceptance_test'

class AcceptanceTests
  
  def self.suite
    suite = Test::Unit::TestSuite.new('AcceptanceTests')
    suite << MochaAcceptanceTest.suite
    suite << StubbaAcceptanceTest.suite
    suite << StandaloneAcceptanceTest.suite
    suite
  end
  
end

Test::Unit::UI::Console::TestRunner.run(AcceptanceTests)
