# Mocking a class method

  product = Product.new
  Product.expects(:find).with(1).returns(product)
  assert_equal product, Product.find(1)

# Mocking an instance method on a real object

  product = Product.new
  product.expects(:save).returns(true)
  assert product.save

# Stubbing instance methods on real object

  prices = [stub(:pence => 1000), stub(:pence => 2000)]
  product = Product.new
  product.stubs(:prices).returns(prices)
  assert_equal [1000, 2000], product.prices.collect {|p| p.pence}

# Stubbing an instance method on all instances of a class

  Product.any_instance.stubs(:name).returns('stubbed_name')
  product = Product.new
  assert_equal 'stubbed_name', product.name

# Traditional mocking

  object = mock()
  object.expects(:expected_method).with(:p1, :p2).returns(:result)
  assert_equal :result, object.expected_method(:p1, :p2)

# Shortcuts

  object = stub(:method1 => :result1, :method2 => :result2)
  assert_equal :result1, object.method1
  assert_equal :result2, object.method2