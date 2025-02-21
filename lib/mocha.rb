# frozen_string_literal: true

require 'mocha/version'

# Mocha's top level namespace, which also provides the ability to {.configure configure} Mocha's behavior.
#
# Methods in the {API} are directly available in +Test::Unit::TestCase+, +Minitest::Unit::TestCase+.
#
# The mock creation methods are {API#mock mock}, {API#stub stub} and {API#stub_everything stub_everything}, all of which return a {Mock}
#
# A {Mock} {Mock#expects expects} or {Mock#stubs stubs} a method, which sets up (returns) an {Expectation}.
#
# An {Expectation} can be further qualified through its {Expectation fluent interface}.
#
# {ParameterMatchers} for {Expectation#with} restrict the parameter values which will match the {Expectation}.
#
# Adapters in {Integration} provide built-in support for +Minitest+ and +Test::Unit+.
#
# Integration {Hooks} enable support for other test frameworks.
module Mocha
end
