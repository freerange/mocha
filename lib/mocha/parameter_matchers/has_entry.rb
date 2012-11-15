require 'mocha/parameter_matchers/base'

module Mocha

  module ParameterMatchers

    # Matches +Hash+ containing entry with +key+ and +value+.
    #
    # @overload def has_entry(key, value)
    #   @param [Object] key key for entry.
    #   @param [Object] value value for entry.
    # @overload def has_entry(single_entry_hash)
    #   @param [Hash] single_entry_hash +Hash+ with single entry.
    #   @raise [ArgumentError] if +single_entry_hash+ does not contain exactly one entry.
    #
    # @return [HasEntry] parameter matcher.
    #
    # @see Expectation#with
    #
    # @example Actual parameter contains expected entry supplied as key and value.
    #   object = mock()
    #   object.expects(:method_1).with(has_entry('key_1', 1))
    #   object.method_1('key_1' => 1, 'key_2' => 2)
    #   # no error raised
    #
    # @example Actual parameter contains expected entry supplied as +Hash+ entry.
    #   object = mock()
    #   object.expects(:method_1).with(has_entry('key_1' => 1))
    #   object.method_1('key_1' => 1, 'key_2' => 2)
    #   # no error raised
    #
    # @example Actual parameter does not contain expected entry supplied as key and value.
    #   object = mock()
    #   object.expects(:method_1).with(has_entry('key_1', 1))
    #   object.method_1('key_1' => 2, 'key_2' => 1)
    #   # error raised, because method_1 was not called with Hash containing entry: 'key_1' => 1
    #
    # @example Actual parameter does not contain expected entry supplied as +Hash+ entry.
    #
    #   object = mock()
    #   object.expects(:method_1).with(has_entry('key_1' => 1))
    #   object.method_1('key_1' => 2, 'key_2' => 1)
    #   # error raised, because method_1 was not called with Hash containing entry: 'key_1' => 1
    def has_entry(*options)
      param_1 = options.shift
      if options.empty? && param_1.is_a?(Hash)
        case param_1.length
        when 0
          raise ArgumentError.new("Argument has no entries.")
        when 1
          key   = param_1.keys.first
          value = param_1[key]
        else
          raise ArgumentError.new("Argument has multiple entries. Use Mocha::ParameterMatchers#has_entries instead.")
        end
      elsif options.length == 1
        key   = param_1
        value = options.shift
      else
        raise ArgumentError.new("Wrong number of arguments.  has_entry takes either one parameter (must be a hash) or two parameters (any key and value).")
      end
      HasEntry.new(key, value)
    end

    # Parameter matcher which matches when actual parameter contains expected +Hash+ entry.
    class HasEntry < Base

      # @private
      def initialize(key, value)
        @key, @value = key, value
      end

      # @private
      def matches?(available_parameters)
        parameter = available_parameters.shift
        return false unless parameter.respond_to?(:keys) && parameter.respond_to?(:[])
        matching_keys = parameter.keys.select { |key| @key.to_matcher.matches?([key]) }
        matching_keys.any? { |key| @value.to_matcher.matches?([parameter[key]]) }
      end

      # @private
      def mocha_inspect
        "has_entry(#{@key.mocha_inspect} => #{@value.mocha_inspect})"
      end

    end

  end

end
