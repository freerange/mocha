require File.expand_path('../stubbing_non_existent_method_is_checked', __FILE__)
require File.expand_path('../stubbing_existing_method_is_allowed', __FILE__)
require File.expand_path('../stubbing_instance_method', __FILE__)

class StubbingNonExistentInstanceMethodTest < Mocha::TestCase
  include StubbingNonExistentMethodIsChecked
  include StubbingInstanceMethod
end

class StubbingExistingInstanceMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowed
  include StubbingInstanceMethod
end

class StubbingExistingInstanceSuperclassMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowed

  def method_owner
    stub_owner.class.superclass
  end

  def stub_owner
    @stub_owner ||= Class.new(Class.new).new
  end
end
