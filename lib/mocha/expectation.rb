require 'mocha/infinite_range'
require 'mocha/pretty_parameters'

module Mocha
  class Expectation
  
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

    def times(range)
      @count = range
      self
    end
  
    def never
      times(0)
    end
  
    def at_least(minimum)
      times(Range.at_least(minimum))
      self
    end
  
    def at_least_once()
      at_least(1)
      self
    end
  
    def with(*arguments, &parameter_block)
      @parameters, @parameter_block = arguments, parameter_block
      class << @parameters; def to_s; join(', '); end; end
      self
    end
  
    def yields(*parameters)
      @yield = true
      @parameters_to_yield = parameters
      self
    end

    def returns(value)
      @return_value = value
      self
    end
  
    def raises(exception = RuntimeError, message = nil)
      @return_value = lambda{ raise exception, message }
      self
    end

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
  
  end

  class Stub < Expectation
  
    def verify
      true
    end
  
  end

  class MissingExpectation < Expectation
  
    def initialize(method_name, expectations = [])
      super(method_name)
      @expectations = expectations
      @invoked = true
    end
  
    def verify
      msg = "Unexpected message #{message}"
      msg << "\nSimilar expectations #{similar_expectations.collect { |expectation| expectation.message }.join("\n") }" unless similar_expectations.empty?
      raise Test::Unit::AssertionFailedError, msg if @invoked
    end
  
    def similar_expectations
      @expectations.select { |expectation| expectation.method_name == self.method_name }
    end
  
  end
end