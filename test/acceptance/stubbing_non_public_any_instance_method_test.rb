require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed_shared_tests', __FILE__)
require File.expand_path('../stubbing_any_instance_method_helper', __FILE__)

class StubbingNonPublicAnyInstanceMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowedSharedTests
  include StubbingAnyInstanceMethodHelper
end

class StubbingPrivateAnyInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodSharedTests
  include StubbingAnyInstanceMethodHelper

  def visibility
    :private
  end
end

class StubbingProtectedAnyInstanceMethodTest < Mocha::TestCase
  include StubbingNonPublicMethodSharedTests
  include StubbingAnyInstanceMethodHelper

  def visibility
    :protected
  end
end
