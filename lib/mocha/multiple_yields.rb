module Mocha

  class MultipleYields

    attr_reader :parameter_groups

    def initialize(*parameter_groups)
      @parameter_groups = parameter_groups
    end

    def each
      @parameter_groups.map do |parameter_group|
        yield(parameter_group)
      end.last
    end

  end

end

