require 'test_helper'
require 'auto_mocha'
require 'mocha'

class Product < ActiveRecord::Base
   
  def self.released_since(cutoff_date)
    find(:all, :conditions => ['release_date > :date', {:date => cutoff_date}])
  end
  
  def sales_with_price_exceeding(price_threshold)
    sales.select { |sale| sale.price > price_threshold }
  end
  
end

class AutoMochaAcceptanceTest < Test::Unit::TestCase
  
  def test_should_find_all_products_released_since_specified_date
    new_releases = [Product.new]
    Product.expects(:find).with(:all, :conditions => ['release_date > :date', {:date => :cutoff_date}]).returns(new_releases)
    assert_equal new_releases, Product.released_since(:cutoff_date)
  end
  
  def test_should_find_sales_for_this_product_which_exceeded_specified_price
    product = Product.new
    cheap_order = Mocha.new
    cheap_order.expects(:price).returns(5)
    expensive_order = Mocha.new
    expensive_order.expects(:price).returns(15)
    orders = [cheap_order, expensive_order]
    product.expects(:sales).returns(orders)
    assert_equal [expensive_order], product.sales_with_price_exceeding(10)
  end
  
end