module Mocha

  class ExpectationList

    def initialize(klass = nil)
      @expectations = []
      @klass = klass
    end

    def add(expectation)
      @expectations.unshift(expectation)
      expectation
    end

    def remove_all_matching_method(method_name)
      @expectations.reject! { |expectation| expectation.matches_method?(method_name) }
    end

    def matches_method?(method_name)
      @expectations.any? { |expectation| expectation.matches_method?(method_name) }
    end

    def match(method_name, *arguments)
      matching_expectations(method_name, *arguments).first
    end

    def match_allowing_invocation(method_name, *arguments)
      matching_expectations(method_name, *arguments).detect { |e| e.invocations_allowed? }
    end

    def verified?(assertion_counter = nil)
      @expectations.all? { |expectation| expectation.verified?(assertion_counter) }
    end

    def to_a
      @expectations
    end

    def to_set
      @expectations.to_set
    end

    def length
      @expectations.length
    end

    def any?
      @expectations.any?
    end

    private

    def local_matching_expectations(method_name, *arguments)
      @expectations.select { |e| e.match?(method_name, *arguments) }
    end

    def matching_expectations(method_name, *arguments)
      expectations = local_matching_expectations(method_name, *arguments)
      if @klass
        klass = @klass
        while klass
          mocha = klass.mocha if klass.instance_variable_defined?(:@mocha)
          klass = klass.superclass
          next unless mocha
          expectations += mocha.__expectations__.send(:local_matching_expectations, method_name, *arguments).
            select { |expectation| expectation.including_subclasses? }
        end
      end
      expectations
    end

  end

end
