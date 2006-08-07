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
    mock = Mocha::Mock.new
    expectations.each do |method, result|
      mock.expects(method).returns(result)
    end
    mocks << mock
    mock
  end
  
  def stub(expectations = {})
    mock = Mocha::Mock.new
    expectations.each do |method, result|
      mock.stubs(method).returns(result)
    end
    mocks << mock
    mock
  end

  def teardown_mocks
    mocks.each { |mock| mock.verify }
    reset_mocks
  end
  
end

