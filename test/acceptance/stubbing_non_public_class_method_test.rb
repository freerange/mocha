require File.expand_path('../stubbing_non_public_method_is_checked', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed', __FILE__)
require File.expand_path('../stubbing_class_method', __FILE__)

class StubbingNonPublicClassMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowed
  include StubbingClassMethod
end

class StubbingPrivateClassMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodIsChecked
  include StubbingClassMethod

  def visibility
    :private
  end
end

class StubbingProtectedClassMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodIsChecked
  include StubbingClassMethod

  def visibility
    :protected
  end
end
