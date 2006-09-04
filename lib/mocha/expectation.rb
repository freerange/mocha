require 'mocha/infinite_range'
require 'mocha/pretty_parameters'

module Mocha
  # Methods on expectations returned from Mocha::MockMethods#expects and Mocha::MockMethods#stubs
  class Expectation
  
    # :stopdoc:
    
    class InvalidExpectation < Exception; end
    
    class AlwaysEqual
      def ==(other)
        true
      end
      def to_s
        "** any **"
      end
    end
  
    attr_reader :method_name, :backtrace

    def initialize(method_name, backtrace = nil)
      @method_name = method_name
      @count = 1
      @parameters, @parameter_block = AlwaysEqual.new, nil
      @invoked, @return_value = 0, nil
      @backtrace = backtrace || caller
    end
    
    def yield?
      @yield
    end

    def match?(method_name, *arguments)
      if @parameter_block then
        @parameter_block.call(*arguments)
      else
        (@method_name == method_name) and (@parameters == arguments)
      end
    end

    # :startdoc:
    
    # :call-seq: times(range) -> expectation
    #
    # Modifies expectation so that the number of calls to the expected method must be within a specific +range+.
    #
    # +range+ can be specified as an exact integer or as a range of integers
    #   object = mock()
    #   object.expects(:expected_method).times(3)
    #   3.times { object.expected_method } # => verify succeeds
    #
    #   object = mock()
    #   object.expects(:expected_method).times(3)
    #   2.times { object.expected_method } # => verify fails
    #
    #   object = mock()
    #   object.expects(:expected_method).times(2..4)
    #   3.times { object.expected_method } # => verify succeeds
    #
    #   object = mock()
    #   object.expects(:expected_method).times(2..4)
    #   object.expected_method # => verify fails
    def times(range)
      @count = range
      self
    end
  
    # :call-seq: never -> expectation
    #
    # Modifies expectation so that the expected method must never be called.
    #   object = mock()
    #   object.expects(:expected_method).never
    #   object.expected_method # => verify fails
    #
    #   object = mock()
    #   object.expects(:expected_method).never
    #   object.expected_method # => verify succeeds
    def never
      times(0)
    end
  
    # :call-seq: at_least(minimum) -> expectation
    #
    # Modifies expectation so that the expected method must be called at least a +minimum+ number of times.
    #   object = mock()
    #   object.expects(:expected_method).at_least(2)
    #   3.times { object.expected_method } # => verify succeeds
    #
    #   object = mock()
    #   object.expects(:expected_method).at_least(2)
    #   object.expected_method # => verify fails
    def at_least(minimum)
      times(Range.at_least(minimum))
      self
    end
  
    # :call-seq: at_least_once() -> expectation
    #
    # Modifies expectation so that the expected method must be called at least once.
    #   object = mock()
    #   object.expects(:expected_method).at_least_once
    #   object.expected_method # => verify succeeds
    #
    #   object = mock()
    #   object.expects(:expected_method).at_least_once
    #   # => verify fails
    def at_least_once()
      at_least(1)
      self
    end
  
    # :call-seq: with(*arguments, &parameter_block) -> expectation
    #
    # Modifies expectation so that the expected method must be called with specified +arguments+.
    #   object = mock()
    #   object.expects(:expected_method).with(:param1, :param2)
    #   object.expected_method(:param1, :param2) # => verify succeeds
    #
    #   object = mock()
    #   object.expects(:expected_method).with(:param1, :param2)
    #   object.expected_method(:param3) # => verify fails
    # If a +parameter_block+ is given, the block is called with the parameters passed to the expected method.
    # The expectation is matched if the block evaluates to +true+.
    #   object = mock()
    #   object.expects(:expected_method).with() { |value| value % 4 == 0 }
    #   object.expected_method(16) # => verify succeeds
    #
    #   object = mock()
    #   object.expects(:expected_method).with() { |value| value % 4 == 0 }
    #   object.expected_method(17) # => verify fails
    def with(*arguments, &parameter_block)
      @parameters, @parameter_block = arguments, parameter_block
      class << @parameters; def to_s; join(', '); end; end
      self
    end
  
    # :call-seq: yields(*parameters) -> expectation
    #
    # Modifies expectation so that when the expected method is called, it yields with the specified +parameters+.
    #   object = mock()
    #   object.expects(:expected_method).yields('result')
    #   yielded_value = nil
    #   object.expected_method { |value| yielded_value = value }
    #   yielded_value # => 'result'
    def yields(*parameters)
      @yield = true
      @parameters_to_yield = parameters
      self
    end

    # :call-seq: returns(value) -> expectation
    #
    # Modifies expectation so that when the expected method is called, it returns the specified +value+.
    #   object = mock()
    #   object.expects(:expected_method).returns('result')
    #   object.expected_method # => 'result'
    # If +value+ is a Proc, then expected method will return result of calling Proc.
    #   object = mock()
    #   results = [111, 222]
    #   object.stubs(:expected_method).returns(lambda { results.shift })
    #   object.expected_method # => 111
    #   object.expected_method # => 222
    def returns(value)
      @return_value = value
      self
    end
  
    # :call-seq: raises(exception = RuntimeError, message = nil) -> expectation
    #
    # Modifies expectation so that when the expected method is called, it raises the specified +exception+ with the specified +message+.
    #   object = mock()
    #   object.expects(:expected_method).raises(Exception, 'message')
    #   object.expected_method # => raises exception of class Exception and with message 'message'
    def raises(exception = RuntimeError, message = nil)
      @return_value = lambda{ raise exception, message }
      self
    end

    # :stopdoc:
    
    def invoke
      @invoked += 1
      yield(*@parameters_to_yield) if yield? and block_given?
      @return_value.is_a?(Proc) ? @return_value.call : @return_value
    end

    def verify
      yield(self) if block_given?
      unless (@count === @invoked) then
        failure = Test::Unit::AssertionFailedError.new("#{message}: expected calls: #{@count}, actual calls: #{@invoked}")
        failure.set_backtrace(backtrace)
        raise failure
      end
    end
  
    def message
      params = @parameters.is_a?(Array) ? @parameters : [@parameters.to_s]
      params = PrettyParameters.new(params)
      ":#{@method_name}(#{params.pretty})"
    end
  
    # :startdoc:
    
  end

  # :stopdoc:
  
  class Stub < Expectation
  
    def verify
      true
    end
  
  end

  class MissingExpectation < Expectation
  
    def initialize(method_name, mock, expectations = [])
      super(method_name)
      @mock, @expectations = mock, expectations
      @invoked = true
    end
  
    def verify
      msg = "Unexpected message #{message} sent to #{@mock.mocha_inspect}"
      msg << "\nSimilar expectations #{similar_expectations.collect { |expectation| expectation.message }.join("\n") }" unless similar_expectations.empty?
      raise Test::Unit::AssertionFailedError, msg if @invoked
    end
  
    def similar_expectations
      @expectations.select { |expectation| expectation.method_name == self.method_name }
    end
  
  end

  # :startdoc:
  
end