require 'mocha/ruby_version'
require 'mocha/integration/mini_test'

unless Mocha::Integration::Minitest.activate
  raise "Minitest must be loaded *before* `require 'mocha/minitest'`."
end
