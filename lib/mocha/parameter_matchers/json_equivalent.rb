require 'mocha/parameter_matchers/base'
require 'multi_json'

module Mocha

  module ParameterMatchers

    # :call-seq: json_equivalent(object) -> parameter_matcher
    #
    # Matches any JSON that represents the specified +object+
    #   object = mock()
    #   object.expects(:method_1).with(json_equivalent({"foo" => "bar"}))
    #   object.method_1("{\"foo\":\"bar\"}")
    #   # no error raised
    #
    #   object = mock()
    #   object.expects(:method_1).with(json_equivalent({"foo" => "bar"}))
    #   object.method_1("{\"foo\":\"BAD\"}")
    #   # error raised, because method_1 was not called with JSON representing the specified Hash
    def json_equivalent(object)
      JsonEquivalent.new(object)
    end

    class JsonEquivalent < Base # :nodoc:

      def initialize(object)
        @object = object
      end

      def matches?(available_parameters)
        parameter = available_parameters.shift
        @object == MultiJson.decode(parameter)
      end

      def mocha_inspect
        "json_equivalent(#{@object.mocha_inspect})"
      end

    end

  end

end
