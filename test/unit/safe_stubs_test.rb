require File.expand_path('../../test_helper', __FILE__)
require 'mocha/object_methods'
require 'mocha/mockery'
require 'mocha/mock'
require 'mocha/expectation_error_factory'
require 'mocha/names'

class SafeStubsTest < Mocha::TestCase

  def setup
    Mocha::Mockery.setup
  end

  def teardown
    Mocha::Mockery.teardown
  end

  DEFAULT_FLAVOR = 'banana'
  DEFAULT_ICING = 'lemon glaze'

  class Donut
    def flavor
      DEFAULT_FLAVOR
    end

    def icing
      DEFAULT_ICING
    end
  end

  def test_unstubbed_objects_still_answer_as_expected
    assert_equal DEFAULT_FLAVOR, donut.flavor
    assert_equal DEFAULT_ICING, donut.icing
  end

  BLUEBERRY = 'blueberry'

  def test_safe_stubbing_overrides_object_methods
    donut.safe_stubs flavor: BLUEBERRY
    assert_equal BLUEBERRY, donut.flavor
    assert_equal DEFAULT_ICING, donut.icing
  end

  BLUE = 'blue'

  def test_safe_stubs_cannot_add_additional_methods_to_object_interface
    refute donut.respond_to? :favorite_color
    assert_raises NoMethodError do
      donut.favorite_color
    end

    assert_raises Mocha::MethodCannotBeSafelyStubbed do
      donut.safe_stubs favorite_color: BLUE
    end
  end

  private

  def donut
    @donut ||= Donut.new
  end
end
