require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed_shared_tests', __FILE__)

class StubbingNonPublicAnyInstanceMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowedSharedTests

  def stub_owner
    method_owner.any_instance
  end

  def method_owner
    @klass ||= Class.new
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
