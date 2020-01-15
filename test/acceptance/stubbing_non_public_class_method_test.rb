require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed_shared_tests', __FILE__)
require File.expand_path('../stubbing_class_method_helper', __FILE__)

class StubbingNonPublicClassMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowedSharedTests
  include StubbingClassMethodHelper
end

class StubbingPrivateClassMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodSharedTests
  include StubbingClassMethodHelper

  def visibility
    :private
  end
end

class StubbingProtectedClassMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodSharedTests
  include StubbingClassMethodHelper

  def visibility
    :protected
  end
end
