module Mocha

  module Integration

    module Bacon

      class AssertionCounter

        def initialize(counter)
          @counter = counter
        end

        def increment
          @counter[:requirements] += 1
        end

      end

    end

  end

end
