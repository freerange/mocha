require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)
require File.expand_path('../stubbing_existing_method_is_allowed_shared_tests', __FILE__)

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
end

class StubbingExistingClassMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowedSharedTests

  def method_owner
    stub_owner.singleton_class
  end

  def stub_owner
    @stub_owner ||= Class.new
  end
end

class StubbingExistingSuperclassMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowedSharedTests

  def method_owner
    stub_owner.superclass.singleton_class
  end

  def stub_owner
    @stub_owner ||= Class.new(Class.new)
  end
end
