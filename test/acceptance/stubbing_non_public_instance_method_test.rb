require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed_shared_tests', __FILE__)

class StubbingNonPublicInstanceMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowedSharedTests

  def stub_owner
    @stub_owner ||= Class.new.new
  end

  def method_owner
    stub_owner.class
  end
end

module StubbingNonPublicInstanceMethodSharedTests
  include StubbingNonPublicMethodSharedTests

  def stub_owner
    @stub_owner ||= Class.new.new
  end

  def method_owner
    stub_owner.class
  end
end

class StubbingPrivateInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicInstanceMethodSharedTests

  def visibility
    :private
  end
end

class StubbingProtectedInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicInstanceMethodSharedTests

  def visibility
    :protected
  end
end
