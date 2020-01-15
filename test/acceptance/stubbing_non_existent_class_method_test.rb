require File.expand_path('../stubbing_non_existent_method_is_checked', __FILE__)
require File.expand_path('../stubbing_existing_method_is_allowed', __FILE__)
require File.expand_path('../stubbing_class_method', __FILE__)

class StubbingNonExistentClassMethodTest < Mocha::TestCase
  include StubbingNonExistentMethodIsChecked
  include StubbingClassMethod
end

class StubbingExistingClassMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowed
  include StubbingClassMethod
end

class StubbingExistingSuperclassMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowed

  def method_owner
    stub_owner.superclass.singleton_class
  end

  def stub_owner
    @stub_owner ||= Class.new(Class.new)
  end
end
