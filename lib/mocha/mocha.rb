require 'mocha/mocha_methods'
require 'test/unit/assertions'

class Mocha
  
  include MochaMethods
  
  attr_reader :mocked
  
  def initialize(*arguments)
    @mocked = arguments.shift unless arguments.first.is_a?(Hash)
    @mocked ||= always_responds
    expectations = arguments.shift || {}
    expectations.each do |method_name, result|
      expects(method_name).returns(result)
    end
  end
  
  def expects(symbol)
    raise Test::Unit::AssertionFailedError, "Cannot replace #{symbol} as #{@mocked} does not respond to it." unless @mocked.respond_to?(symbol)
    super
  end
  
  def always_responds
    Class.new { def respond_to?(symbol); true; end }.new
  end

end