require File.expand_path('../stubbing_non_existent_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_existing_method_is_allowed_shared_tests', __FILE__)
require File.expand_path('../stubbing_class_method_helper', __FILE__)

class StubbingNonExistentClassMethodTest < Mocha::TestCase
  include StubbingNonExistentMethodSharedTests
  include StubbingClassMethodHelper
end

class StubbingExistingClassMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowedSharedTests
  include StubbingClassMethodHelper
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
