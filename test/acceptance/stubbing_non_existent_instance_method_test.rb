require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)
require File.expand_path('../stubbing_existing_method_is_allowed_shared_tests', __FILE__)
require File.expand_path('../stubbing_instance_method_helper', __FILE__)

class StubbingNonExistentInstanceMethodTest < Mocha::TestCase
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def setup
    super
    @instance = Class.new.new
  end

  def configure_violation(config, treatment)
    config.stubbing_non_existent_method = treatment
  end

  def potential_violation
    @instance.stubs(:non_existent_method)
  end

  def message_on_violation
    "stubbing non-existent method: #{@instance.mocha_inspect}.non_existent_method"
  end
end

class StubbingExistingInstanceMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowedSharedTests
  include StubbingInstanceMethodHelper
end

class StubbingExistingInstanceSuperclassMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowedSharedTests

  def method_owner
    stub_owner.class.superclass
  end

  def stub_owner
    @stub_owner ||= Class.new(Class.new).new
  end
end
