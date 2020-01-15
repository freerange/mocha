require File.expand_path('../stubbing_non_public_method_shared_tests', __FILE__)
require File.expand_path('../stubbing_public_method_is_allowed_shared_tests', __FILE__)
require File.expand_path('../stubbing_instance_method_helper', __FILE__)

class StubbingNonPublicInstanceMethodTest < Mocha::TestCase
  include StubbingPublicMethodIsAllowedSharedTests
  include StubbingInstanceMethodHelper
end

module StubbingNonPublicInstanceMethodSharedTests
  include StubbingNonPublicMethodSharedTests
  include StubbingInstanceMethodHelper
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
