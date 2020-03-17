# frozen_string_literal: true

module Mocha
  class Cardinality
    INFINITY = 1 / 0.0

    def initialize(required = 0, maximum = INFINITY)
      range(required, maximum)
      @invocations = []
    end

    def range(at_least = 0, at_most = INFINITY)
      @required = at_least
      @maximum = at_most
      self
    end

    def <<(invocation)
      @invocations << invocation
    end

    def invocations_allowed?
      @invocations.size < maximum
    end

    def invocations_never_allowed?
      maximum.zero?
    end

    def satisfied?
      @invocations.size >= required
    end

    def needs_verifying?
      !allowed_any_number_of_times?
    end

    def verified?
      (@invocations.size >= required) && (@invocations.size <= maximum)
    end

    def allowed_any_number_of_times?
      required.zero? && infinite?(maximum)
    end

    def used?
      @invocations.any? || maximum.zero?
    end

    def anticipated_times
      if allowed_any_number_of_times?
        'allowed any number of times'
      elsif required.zero? && maximum.zero?
        "expected #{count(maximum)}"
      elsif required == maximum
        "expected exactly #{count(required)}"
      elsif infinite?(maximum)
        "expected at least #{count(required)}"
      elsif required.zero?
        "expected at most #{count(maximum)}"
      else
        "expected between #{required} and #{count(maximum)}"
      end
    end

    def invoked_times
      "invoked #{count(@invocations.size)}"
    end

    def actual_invocations
      @invocations.map(&:full_description).join
    end

    protected

    attr_reader :required, :maximum

    def count(number)
      case number
      when 0 then 'never'
      when 1 then 'once'
      when 2 then 'twice'
      else "#{number} times"
      end
    end

    def infinite?(number)
      number.respond_to?(:infinite?) && number.infinite?
    end
  end
end
