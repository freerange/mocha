module Mocha
  class MultipleYields
    attr_reader :parameter_groups

    def initialize(*parameter_groups)
      @parameter_groups = parameter_groups
    end
  end
end
