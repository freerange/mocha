require 'mocha/mock'

# Methods added to TestCase allowing creation of mock objects.
#
# Mocks created this way will have their expectations automatically verified at the end of the test.
#
# See Mocha::MockMethods for methods on mock objects.
module Mocha
  module AutoVerify
  
    # :stopdoc:
  
    def self.included(base)
      base.add_teardown_method(:teardown_mocks)
    end

    def mocks
      @mocks ||= []
    end
  
    def reset_mocks
      @mocks = nil
    end
  
    # :startdoc:

    # :call-seq: mock(*args) -> mock object
    #
    # Creates a mock object.
    # +args+ can either be a string, string and a hash or just a hash.
    # The string is used to name the mock.
    # The hash contains stubbed method name symbols as keys and corresponding return values as values.
    #
    # Note that (contrary to expectations set up by #stub) these expectations <b>must</b> be fulfilled during the test.
    #   def test_product
    #     product = mock(:name => 'ipod', :price => 100)
    #     assert_equal 'ipod', product.name
    #     assert_equal 100, product.price
    #     # an error will be raised unless both Product#name and Product#price have been called
    #   end 
    def mock(*args)
      name, expectations = name_and_expectations_from_args(args)
      build_mock_with_expectations(:expects, expectations, name)
    end
  
    # :call-seq: stub(*args) -> mock object
    #
    # Creates a mock object.
    # +args+ can either be a string, string and a hash or just a hash.
    # The string is used to name the mock.
    # The hash contains stubbed method name symbols as keys and corresponding return values as values.
    #
    # Note that (contrary to expectations set up by #mock) these expectations <b>need not</b> be fulfilled during the test.
    #   def test_product
    #     product = stub(:name => 'ipod', :price => 100)
    #     assert_equal 'ipod', product.name
    #     assert_equal 100, product.price
    #     # an error will not be raised even if Product#name and Product#price have not been called
    #   end
    def stub(*args)
      name, expectations = name_and_expectations_from_args(args)
      build_mock_with_expectations(:stubs, expectations, name)
    end
  
    # :call-seq: stub_everything(*args) -> mock object
    #
    # Creates a mock object that accepts calls to any method name. By default it will return +nil+ for any method call.
    #
    # +args+ works the same way as in #mock and #stub.
    #   def test_product
    #     product = stub_everything(:price => 100)
    #     assert_nil product.name
    #     assert_nil product.any_old_method
    #     assert_equal 100, product.price
    #   end
    def stub_everything(*args)
      name, expectations = name_and_expectations_from_args(args)
      build_mock_with_expectations(:stub_everything, expectations, name)
    end

    # :stopdoc:

    def teardown_mocks
      mocks.each { |mock| mock.verify { add_assertion } }
      reset_mocks
    end
  
    def build_mock_with_expectations(expectation_type = :expects, expectations = {}, name = nil)
      stub_everything = (expectation_type == :stub_everything)
      expectation_type = :stubs if expectation_type == :stub_everything
      mock = Mocha::Mock.new(stub_everything, name)
      expectations.each do |method, result|
        mock.send(expectation_type, method).returns(result)
      end
      mocks << mock
      mock
    end
    
  private

    def name_and_expectations_from_args(args)
      name = args.first.is_a?(String) ? args.delete_at(0) : nil
      expectations = args.first || {}
      [name, expectations]
    end
  
  end
  
end