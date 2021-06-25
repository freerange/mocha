require File.expand_path('../stubbing_non_public_method_is_checked', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed', __FILE__)
require File.expand_path('../stubbing_any_instance_method', __FILE__)

class StubbingNonPublicAnyInstanceMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowed
  include StubbingAnyInstanceMethod
end

class StubbingPrivateAnyInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodIsChecked
  include StubbingAnyInstanceMethod

  def visibility
    :private
  end
end

class StubbingProtectedAnyInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodIsChecked
  include StubbingAnyInstanceMethod

  def visibility
    :protected
  end
end
