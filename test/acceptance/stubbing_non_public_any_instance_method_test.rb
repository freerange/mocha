require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed_shared_tests', __FILE__)

class StubbingNonPublicAnyInstanceMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowedSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stub_owner
    method_owner.any_instance
  end
end

module StubbingNonPublicAnyInstanceMethodSharedTests
  include StubbingNonPublicMethodSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stub_owner
    method_owner.any_instance
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
