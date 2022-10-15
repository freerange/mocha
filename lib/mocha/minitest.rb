require 'mocha/ruby_version'
require 'mocha/integration/mini_test'

unless Mocha::Integration::MiniTest.activate
  raise "MiniTest must be loaded *before* `require 'mocha/minitest'`."
end
