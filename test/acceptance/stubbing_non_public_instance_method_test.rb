require File.expand_path('../stubbing_non_public_method_is_checked', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed', __FILE__)
require File.expand_path('../stubbing_instance_method', __FILE__)

class StubbingNonPublicInstanceMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowed
  include StubbingInstanceMethod
end

class StubbingPrivateInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodIsChecked
  include StubbingInstanceMethod

  def visibility
    :private
  end
end

class StubbingProtectedInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodIsChecked
  include StubbingInstanceMethod

  def visibility
    :protected
  end
end
