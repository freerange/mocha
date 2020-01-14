require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)

class StubbingNonPublicAnyInstanceMethodTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_public_any_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    klass = Class.new do
      def public_method; end
      public :public_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:public_method)
    end
    assert_passed(test_result)
  end
end

module StubbingNonPublicAnyInstanceMethodSharedTests
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def setup
    super
    @klass = Class.new
    @klass.send(:define_method, :non_public_method) {}
    @klass.send(visibility, :non_public_method)
  end

  def configure_violation(config, treatment)
    config.stubbing_non_public_method = treatment
  end

  def potential_violation
    @klass.any_instance.stubs(:non_public_method)
  end

  def message_on_violation
    "stubbing non-public method: #{@klass.any_instance.mocha_inspect}.non_public_method"
  end
end

class StubbingPrivateAnyInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicAnyInstanceMethodSharedTests

  def visibility
    :private
  end
end

class StubbingProtectedAnyInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicAnyInstanceMethodSharedTests

  def visibility
    :protected
  end
end
