require File.expand_path('../stubbing_non_existent_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_existing_method_is_allowed_shared_tests', __FILE__)
require File.expand_path('../stubbing_instance_method_helper', __FILE__)

class StubbingNonExistentInstanceMethodTest < Mocha::TestCase
  include StubbingNonExistentMethodSharedTests
  include StubbingInstanceMethodHelper
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
