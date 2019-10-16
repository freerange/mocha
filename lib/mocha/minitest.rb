require 'mocha/integration/mini_test'

unless Mocha::Integration::MiniTest.activate
  Deprecation.warning("MiniTest must be loaded *before* `require 'mocha/minitest'`.")
end
