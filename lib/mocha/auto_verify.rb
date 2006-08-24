require 'mocha/mock'

module AutoVerify
  
  def self.included(base)
    base.add_teardown_method(:teardown_mocks)
  end

  def mocks
    @mocks ||= []
  end
  
  def reset_mocks
    @mocks = nil
  end

  def mock(expectations = {})
    build_mock_with_expectations(:expects, expectations)
  end
  
  def stub(expectations = {})
    build_mock_with_expectations(:stubs, expectations)
  end
  
  def stub_everything
    Mocha::Mock.new(stub_everything = true)
  end

  def teardown_mocks
    mocks.each { |mock| mock.verify { add_assertion } }
    reset_mocks
  end
  
  def build_mock_with_expectations(expectation_type = :expects, expectations = {})
    mock = Mocha::Mock.new
    expectations.each do |method, result|
      mock.send(expectation_type, method).returns(result)
    end
    mocks << mock
    mock
  end
  
end

