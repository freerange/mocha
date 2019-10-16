require 'mocha/integration/test_unit'

unless Mocha::Integration::TestUnit.activate
  Deprecation.warning("Test::Unit must be loaded *before* `require 'mocha/test_unit'`.")
end
