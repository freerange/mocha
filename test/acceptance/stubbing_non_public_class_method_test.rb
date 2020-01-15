require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed_shared_tests', __FILE__)

class StubbingNonPublicClassMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowedSharedTests

  def stub_owner
    @stub_owner ||= Class.new
  end

  def method_owner
    stub_owner.singleton_class
  end
end

module StubbingNonPublicClassMethodSharedTests
  include StubbingNonPublicMethodSharedTests

  def stub_owner
    @stub_owner ||= Class.new
  end

  def method_owner
    stub_owner.singleton_class
  end
end

class StubbingPrivateClassMethodTest < Mocha::TestCase
  include StubbingNonPublicClassMethodSharedTests

  def visibility
    :private
  end
end

class StubbingProtectedClassMethodTest < Mocha::TestCase
  include StubbingNonPublicClassMethodSharedTests

  def visibility
    :protected
  end
end
