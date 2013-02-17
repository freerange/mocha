## Mocha [![build status](https://secure.travis-ci.org/freerange/mocha.png)](https://secure.travis-ci.org/freerange/mocha) [![Gem Version](https://badge.fury.io/rb/mocha.png)](http://badge.fury.io/rb/mocha)

### Description

* A Ruby library for mocking and stubbing.
* A unified, simple and readable syntax for both full & partial mocking.
* Built-in support for MiniTest and Test::Unit.
* Supported by many other test frameworks.

### Installation

#### Gem

Install the latest version of the gem with the following command...

    $ gem install mocha

Note: If you are intending to use Mocha with Test::Unit or MiniTest, you should only load Mocha *after* loading the relevant test library...

    require "test/unit"
    require "mocha/setup"

#### Bundler

If you're using Bundler, ensure the correct load order by not auto-requiring Mocha in the `Gemfile` and then load it later once you know the test library has been loaded...

    # Gemfile
    gem "mocha", :require => false

    # Elsewhere after Bundler has loaded gems
    require "test/unit"
    require "mocha/setup"

#### Rails

If you're loading Mocha using Bundler within a Rails application, you should ensure Mocha is not auto-required (as above) and load Mocha manually e.g. at the bottom of your `test_helper.rb`.

    # Gemfile in Rails app
    gem "mocha", :require => false

    # At bottom of test_helper.rb
    require "mocha/setup"

Note: Using the latest version of Mocha (0.13.2) with the latest versions of Rails (e.g. 3.2.12) or _some_ recent versions of Rails (e.g. 3.1.10, or 3.0.19), you will see the following Mocha deprecation warning:

    *** Mocha deprecation warning: Change `require 'mocha'` to `require 'mocha/setup'`.

This will happen until new versions of Rails are released incorporating the following pull requests:

  * 3-2-stable - https://github.com/rails/rails/pull/8200
  * ~~3-1-stable - https://github.com/rails/rails/pull/8871~~ [released in 3.1.11]
  * ~~3-0-stable - https://github.com/rails/rails/pull/8872~~ [released in 3.0.20]

The deprecation warning will not cause any problems, but if you don't like seeing then you could do one of the following:

##### Option 1 - Disable Mocha deprecation warnings with a Rails initializer

    # config/mocha.rb
    if Rails.env.test? || Rails.env.development?
      require "mocha/version"
      require "mocha/deprecation"
      if Mocha::VERSION == "0.13.2" && Rails::VERSION::STRING == "3.2.12"
        Mocha::Deprecation.mode = :disabled
      end
    end

Note 1: I have intentionally made this brittle against patch releases of Mocha and Rails, because this way you are more likely to notice when you no longer need the initializer.
Note 2: This will not work with recent versions of the Test::Unit gem (see below).

##### Option 2 - Use "edge" Rails or one of the relevant "stable" branches of Rails

    # Gemfile
    gem "rails", git: "git://github.com/rails/rails.git", branch: "3-2-stable"
    group :test do
      gem "mocha", :require => false
    end

    # test/test_helper.rb
    require "mocha/setup"

##### Option 3 - Downgrade to the latest 0.12.x version of Mocha

    # Gemfile in Rails app
    gem "mocha", "~> 0.12.10", :require => false

    # At bottom of test_helper.rb
    require "mocha"

Note: This isn't as bad as it sounds, because there aren't many changes in Mocha 0.13.x that are not in 0.12.x.

#### Rails with Test::Unit

Unfortunately due to Rails relying on Mocha & Test::Unit internals, there is a problem with using recent released versions of Rails with the latest version of Mocha and recent versions of the Test::Unit gem.

In this case you will have to use either Option 2 or Option 3 (see above). Option 1 will not work.

#### Rails Plugin

Install the Rails plugin...

    $ rails plugin install git://github.com/freerange/mocha.git

Note: As of version 0.9.8, the Mocha plugin is not automatically loaded at plugin load time. Instead it must be manually loaded e.g. at the bottom of your `test_helper.rb`.

#### Know Issues

* Versions 0.10.2, 0.10.3 & 0.11.0 of the Mocha gem were broken.
* Versions 0.9.6 & 0.9.7 of the Mocha Rails plugin were broken.
* Please do not use these versions.

### Usage

#### Quick Start

```ruby
require 'test/unit'
require 'mocha/setup'

class MiscExampleTest < Test::Unit::TestCase
  def test_mocking_a_class_method
    product = Product.new
    Product.expects(:find).with(1).returns(product)
    assert_equal product, Product.find(1)
  end

  def test_mocking_an_instance_method_on_a_real_object
    product = Product.new
    product.expects(:save).returns(true)
    assert product.save
  end

  def test_stubbing_instance_methods_on_real_objects
    prices = [stub(:pence => 1000), stub(:pence => 2000)]
    product = Product.new
    product.stubs(:prices).returns(prices)
    assert_equal [1000, 2000], product.prices.collect {|p| p.pence}
  end

  def test_stubbing_an_instance_method_on_all_instances_of_a_class
    Product.any_instance.stubs(:name).returns('stubbed_name')
    product = Product.new
    assert_equal 'stubbed_name', product.name
  end

  def test_traditional_mocking
    object = mock('object')
    object.expects(:expected_method).with(:p1, :p2).returns(:result)
    assert_equal :result, object.expected_method(:p1, :p2)
  end

  def test_shortcuts
    object = stub(:method1 => :result1, :method2 => :result2)
    assert_equal :result1, object.method1
    assert_equal :result2, object.method2
  end
end
```

#### Mock Objects

```ruby
class Enterprise
  def initialize(dilithium)
    @dilithium = dilithium
  end

  def go(warp_factor)
    warp_factor.times { @dilithium.nuke(:anti_matter) }
  end
end

require 'test/unit'
require 'mocha/setup'

class EnterpriseTest < Test::Unit::TestCase
  def test_should_boldly_go
    dilithium = mock()
    dilithium.expects(:nuke).with(:anti_matter).at_least_once  # auto-verified at end of test
    enterprise = Enterprise.new(dilithium)
    enterprise.go(2)
  end
end
```

#### Partial Mocking

```ruby
class Order
  attr_accessor :shipped_on

  def total_cost
    line_items.inject(0) { |total, line_item| total + line_item.price } + shipping_cost
  end

  def total_weight
    line_items.inject(0) { |total, line_item| total + line_item.weight }
  end

  def shipping_cost
    total_weight * 5 + 10
  end

  class << self
    def find_all
      # Database.connection.execute('select * from orders...
    end
  
    def number_shipped_since(date)
      find_all.select { |order| order.shipped_on > date }.length
    end

    def unshipped_value
      find_all.inject(0) { |total, order| order.shipped_on ? total : total + order.total_cost }
    end
  end
end

require 'test/unit'
require 'mocha/setup'

class OrderTest < Test::Unit::TestCase
  # illustrates stubbing instance method
  def test_should_calculate_shipping_cost_based_on_total_weight
    order = Order.new
    order.stubs(:total_weight).returns(10)
    assert_equal 60, order.shipping_cost
  end

  # illustrates stubbing class method
  def test_should_count_number_of_orders_shipped_after_specified_date
    now = Time.now; week_in_secs = 7 * 24 * 60 * 60
    order_1 = Order.new; order_1.shipped_on = now - 1 * week_in_secs
    order_2 = Order.new; order_2.shipped_on = now - 3 * week_in_secs
    Order.stubs(:find_all).returns([order_1, order_2])
    assert_equal 1, Order.number_shipped_since(now - 2 * week_in_secs)
  end

  # illustrates stubbing instance method for all instances of a class
  def test_should_calculate_value_of_unshipped_orders
    Order.stubs(:find_all).returns([Order.new, Order.new, Order.new])
    Order.any_instance.stubs(:shipped_on).returns(nil)
    Order.any_instance.stubs(:total_cost).returns(10)
    assert_equal 30, Order.unshipped_value
  end
end
```

### Useful Links

* [Official Documentation](http://gofreerange.com/mocha/docs/)
* [Source Code](http://github.com/freerange/mocha)
* [Mailing List](http://groups.google.com/group/mocha-developer)
* [James Mead's Blog](http://jamesmead.org/blog/)
* [An Introduction To Mock Objects In Ruby](http://jamesmead.org/talks/2007-07-09-introduction-to-mock-objects-in-ruby-at-lrug/)
* [Mocks Aren't Stubs](http://martinfowler.com/articles/mocksArentStubs.html)
* [Growing Object-Oriented Software Guided By Tests](http://www.growing-object-oriented-software.com/)
* [Mock Roles Not Objects](http://www.jmock.org/oopsla2004.pdf)
* [jMock](http://www.jmock.org/)

### Contributing

* Fork the repository.
* Make your changes in a branch (including tests).
* Ensure all of the tests run against all supported versions of Test::Unit, MiniTest & Ruby by running ./build-matrix.rb (note that currently this makes a *lot* of assumptions about your local environment e.g. rbenv installed with specific Ruby versions).
* Send us a pull request from your fork/branch.

### Contributors

See this [list of contributors](https://github.com/freerange/mocha/graphs/contributors).

### Translations

* [Serbo-Croatian](http://science.webhostinggeeks.com/mocha) by [WHG Team](http://webhostinggeeks.com/).

### History

Mocha was initially harvested from projects at [Reevoo](http://www.reevoo.com/). It's syntax is heavily based on that of [jMock](http://www.jmock.org).

### License

&copy; Copyright Revieworld Ltd. 2006

You may use, copy and redistribute this library under the same terms as [Ruby itself](http://www.ruby-lang.org/en/LICENSE.txt) or under the [MIT license](http://www.opensource.org/licenses/MIT).
