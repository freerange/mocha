require 'mocha/parameter_matchers/base'

module Mocha
  module ParameterMatchers
    # Matches any object that responds with +true+ to +include?(item)+
    # for all items, taking into account that each object element should+
    # be matched with a different item
    #
    # @param [*Array] items expected items.
    # @return [IncludesExactly] parameter matcher.
    #
    # @see Expectation#with
    #
    # @example Actual parameter includes exact items.
    #   object = mock()
    #   object.expects(:method_1).with(includes_exactly('foo', 'bar'))
    #   object.method_1(['bar', 'foo'])
    #   # no error raised
    #
    # @example Actual parameter does not include exact items.
    #   object.method_1(['foo', 'bar', 'bar'])
    #   # error raised, because ['foo', 'bar', 'bar'] has an extra 'bar'.
    #
    # @example Actual parameter does not include exact items.
    #   object.method_1(['foo', 'baz'])
    #   # error raised, because ['foo', 'baz'] does not include 'bar'.
    #
    # @example Items does not include all actual parameters.
    #   object.method_1(['foo', 'bar', 'baz])
    #   # error raised, because ['foo', 'bar'] does not include 'baz'.
    #
    # @example Actual parameter includes item which matches nested matcher.
    #   object = mock()
    #   object.expects(:method_1).with(includes_exactly(has_key(:key), 'foo', 'bar'))
    #   object.method_1(['foo', 'bar', {key: 'baz'}])
    #   # no error raised
    #
    # @example Actual parameter does not include item matching nested matcher.
    #   object.method_1(['foo', 'bar', {:other_key => 'baz'}])
    #   # error raised, because no element matches `has_key(:key)` matcher
    #
    # @example Actual parameter is the exact item String.
    #   object = mock()
    #   object.expects(:method_1).with(includes_exactly('bar'))
    #   object.method_1('bar')
    #   # no error raised
    #
    # @example Actual parameter is a String including substring.
    #   object.method_1('foobar')
    #   # error raised, because 'foobar' is not equal 'bar'
    #
    # @example Actual parameter is a Hash including the exact keys.
    #   object = mock()
    #   object.expects(:method_1).with(includes_exactly(:bar))
    #   object.method_1({bar: 2})
    #   # no error raised
    #
    # @example Actual parameter is a Hash including an extra key.
    #   object = mock()
    #   object.expects(:method_1).with(includes_exactly(:bar))
    #   object.method_1({foo: 1, bar: 2,})
    #   # error raised, because items does not include :foo
    #
    # @example Actual parameter is a Hash without the given key.
    #   object.method_1({foo: 1})
    #   # error raised, because hash does not include key 'bar'
    #
    # @example Actual parameter is a Hash with a key matching the given matcher.
    #   object = mock()
    #   object.expects(:method_1).with(includes_exactly(regexp_matches(/ar/)))
    #   object.method_1({'bar' => 2})
    #   # no error raised
    #
    # @example Actual parameter is a Hash no key matching the given matcher.
    #   object.method_1({'baz' => 3})
    #   # error raised, because hash does not include a key matching /ar/
    def includes_exactly(*items)
      IncludesExactly.new(*items)
    end

    # Parameter matcher which matches when actual parameter includes expected values.
    class IncludesExactly < Base
      # @private
      def initialize(*items)
        @items = items
      end

      # @private
      def matches?(available_parameters)
        parameters = available_parameters.shift
        return false unless parameters.respond_to?(:include?)
        return parameters == @items.first if parameters.is_a?(String) && @items.size == 1

        parameters = parameters.keys if parameters.is_a?(Hash)

        @items.each do |item|
          matched_index = parameters.each_index.find { |i| item.to_matcher.matches?([parameters[i]]) }
          return false unless matched_index

          parameters.delete_at(matched_index)
        end

        parameters.empty?
      end

      # @private
      def mocha_inspect
        item_descriptions = @items.map(&:mocha_inspect)
        "includes_exactly(#{item_descriptions.join(', ')})"
      end
    end
  end
end
