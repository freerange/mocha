require File.expand_path('../../test_helper', __FILE__)
require 'mocha/object_methods'
require 'mocha/mockery'
require 'mocha/mock'
require 'mocha/expectation_error_factory'
require 'mocha/names'

class SafeExpectsTest < Mocha::TestCase

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

    def price_for(quantity)
      return unless quantity
      price_in_cents = quantity * unit_price_cents
      "$#{(price_in_cents/100.0).floor}"
    end

    private

    def unit_price_cents
      200
    end
  end

  def test_unstubbed_objects_still_answer_as_expected
    assert_equal DEFAULT_FLAVOR, donut.flavor
    assert_equal DEFAULT_ICING, donut.icing
  end

  BLUEBERRY = 'blueberry'

  def test_safe_expecting_overrides_object_methods
    donut.safe_expects flavor: BLUEBERRY
    assert_equal BLUEBERRY, donut.flavor
    assert_equal DEFAULT_ICING, donut.icing
  end

  RED = 'red'

  def test_safe_expects_cannot_add_additional_methods_to_object_interface
    refute donut.respond_to? :favorite_color
    assert_raises NoMethodError do
      donut.favorite_color
    end

    assert_raises Mocha::MethodCannotBeSafelyExpected do
      donut.safe_expects favorite_color: RED
    end
  end

  FIFTEEN_BUCKS = '$15'

  def test_safely_expects_works_with_arguments
    assert_equal '$20', donut.price_for(10)

    donut.safe_expects(:price_for).with(10).returns FIFTEEN_BUCKS
    assert_equal FIFTEEN_BUCKS, donut.price_for(10)
  end

  def test_can_safe_expect_private_methods
    assert_equal '$20', donut.price_for(10)

    donut.safe_expects(:unit_price_cents).returns 150
    assert_equal FIFTEEN_BUCKS, donut.price_for(10)
  end


  private

  def donut
    @donut ||= Donut.new
  end
end
