require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)

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
  include StubbingNonPublicMethodSharedTests

  def stub_owner
    method_owner.any_instance
  end

  def method_owner
    @klass ||= Class.new
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
