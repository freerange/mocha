require File.expand_path('../../test_helper', __FILE__)
require 'mocha/object_methods'
require 'mocha/mockery'
require 'mocha/mock'
require 'mocha/expectation_error_factory'
require 'mocha/names'
require 'byebug'

class ExpectssNonRegressionTest < Mocha::TestCase

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

  def test_expecting_overrides_object_methods
    donut.expects(:flavor).once.returns BLUEBERRY
    assert_equal BLUEBERRY, donut.flavor
    assert_equal DEFAULT_ICING, donut.icing
  end

  BLUE = 'blue'

  def test_expects_can_additional_methods_to_object_interface
    refute donut.respond_to? :favorite_color
    assert_raises NoMethodError do
      donut.favorite_color
    end

    donut.expects(:favorite_color).returns BLUE
    assert donut.respond_to? :favorite_color
    assert_equal BLUE, donut.favorite_color
  end

  TWENTY_BUCKS = '$20'

  def test_expects_works_with_arguments
    refute donut.respond_to? :price_for
    assert_raises NoMethodError do
      donut.price_for(10)
    end

    donut.expects(:price_for).with(10).returns TWENTY_BUCKS
    assert donut.respond_to? :price_for
    assert_equal TWENTY_BUCKS, donut.price_for(10)
  end

  private

  def donut
    @donut ||= Donut.new
  end
end
