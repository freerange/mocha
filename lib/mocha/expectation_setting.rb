module Mocha
  class ExpectationSetting
    attr_reader :expectations

    def initialize(expectations)
      @expectations = expectations
    end

    %w[
      times twice once never at_least at_least_once at_most at_most_once
      with yields multiple_yields returns raises throws then when in_sequence
    ].each do |method_name|
      define_method(method_name) do |*args, &block|
        ExpectationSetting.new(@expectations.map { |e| e.send(method_name, *args, &block) })
      end
    end
  end
end
