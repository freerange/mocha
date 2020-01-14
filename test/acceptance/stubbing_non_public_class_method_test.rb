require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)

class StubbingNonPublicClassMethodTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_public_class_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    klass = Class.new do
      class << self
        def public_method; end
        public :public_method
      end
    end
    test_result = run_as_test do
      klass.stubs(:public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_method_to_which_class_responds
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    klass = Class.new do
      class << self
        def respond_to?(method, _include_private_methods = false)
          (method == :method_to_which_class_responds)
        end
      end
    end
    test_result = run_as_test do
      klass.stubs(:method_to_which_class_responds)
    end
    assert_passed(test_result)
  end
end

module StubbingNonPublicClassMethodSharedTests
  include StubbingNonPublicMethodSharedTests

  def stub_owner
    @stub_owner ||= Class.new
  end

  def method_owner
    stub_owner.singleton_class
  end
end

class StubbingPrivateClassMethodTest < Mocha::TestCase
  include StubbingNonPublicClassMethodSharedTests

  def visibility
    :private
  end
end

class StubbingProtectedClassMethodTest < Mocha::TestCase
  include StubbingNonPublicClassMethodSharedTests

  def visibility
    :protected
  end
end
