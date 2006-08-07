require 'mocha/mock'

module AutoVerify
  
  def self.included(base)
    unless base.ancestors.include?(self) then
      base.add_teardown_method(:teardown_mocks)
    end
  end

  def mocks
    @mocks ||= []
  end
  
  def reset_mocks
    @mocks = nil
  end

  def mock
    mocks << Mocha::Mock.new
    mocks.last
  end

  def teardown_mocks
    mocks.each { |mock| mock.verify }
    reset_mocks
  end
  
end

