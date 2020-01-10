require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)

class StubbingNonExistentClassMethodTest < Mocha::TestCase
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def setup
    super
    @klass = Class.new
  end

  def configure_violation(config, treatment)
    config.stubbing_non_existent_method = treatment
  end

  def potential_violation
    @klass.stubs(:non_existent_method)
  end

  def message_on_violation
    "stubbing non-existent method: #{@klass.mocha_inspect}.non_existent_method"
  end

  # rubocop:disable Lint/DuplicateMethods
  def test_should_allow_stubbing_existing_public_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def existing_public_method; end
        public :existing_public_method
      end
    end
    test_result = run_as_test do
      klass.stubs(:existing_public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_method_to_which_class_responds
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def respond_to?(method, _include_private = false)
          (method == :method_to_which_class_responds)
        end
      end
    end
    test_result = run_as_test do
      klass.stubs(:method_to_which_class_responds)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_protected_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def existing_protected_method; end
        protected :existing_protected_method
      end
    end
    test_result = run_as_test do
      klass.stubs(:existing_protected_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_private_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def existing_private_method; end
        private :existing_private_method
      end
    end
    test_result = run_as_test do
      klass.stubs(:existing_private_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_public_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      class << self
        def existing_public_method; end
        public :existing_public_method
      end
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.stubs(:existing_public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_protected_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      class << self
        def existing_protected_method; end
        protected :existing_protected_method
      end
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.stubs(:existing_protected_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_private_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      class << self
        def existing_private_method; end
        protected :existing_private_method
      end
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.stubs(:existing_private_method)
    end
    assert_passed(test_result)
  end
  # rubocop:enable Lint/DuplicateMethods
end
