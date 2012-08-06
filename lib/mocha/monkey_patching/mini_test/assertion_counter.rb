module Mocha

  module MonkeyPatching

    module MiniTest

      class AssertionCounter

        def initialize(test_case)
          @test_case = test_case
        end

        def increment
          @test_case.assert(true)
        end

      end

    end

  end

end
