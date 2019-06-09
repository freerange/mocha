require 'minitest/autorun'
require 'minitest/hell'
require 'mocha/minitest'

class MultithreadedMockingTest < Minitest::Test
  (1..10).each do |i|
    define_method "test_#{i}" do
      m = mock('m')
      m.expects("x#{i}".to_sym)
    end
  end
end

class MultithreadedStubbingTest < Minitest::Test
  (1..10).each do |i|
    define_method "test_#{i}" do
      s = stub('m')
      s.stubs("x#{i}".to_sym).returns(i)
      sleep 1
      assert_equal i, s.public_send("x#{i}".to_sym)
    end
  end
end

class MultithreadedClassMethodMockingTest < Minitest::Test
  klass = Class.new
  (1..10).each do |i|
    define_method "test_#{i}" do
      klass.expects("x#{i}".to_sym)
    end
  end
end

class MultithreadedClassMethodStubbingTest < Minitest::Test
  klass = Class.new
  (1..10).each do |i|
    define_method "test_#{i}" do
      klass.stubs(:x).returns(i)
      sleep 1
      assert_equal i, klass.public_send(:x)
    end
  end
end

class MultithreadedAnyInstanceMethodMockingTest < Minitest::Test
  klass = Class.new
  (1..10).each do |i|
    define_method "test_#{i}" do
      klass.any_instance.expects("x#{i}".to_sym)
    end
  end
end

class MultithreadedAnyInstanceMethodStubbingTest < Minitest::Test
  klass = Class.new
  (1..10).each do |i|
    define_method "test_#{i}" do
      klass.any_instance.stubs(:x).returns(i)
      sleep 1
      assert_equal i, klass.new.public_send(:x)
    end
  end
end
