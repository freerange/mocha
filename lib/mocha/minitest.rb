# frozen_string_literal: true

require 'mocha/integration/minitest'

unless Mocha::Integration::Minitest.activate
  raise "Minitest must be loaded *before* `require 'mocha/minitest'`."
end
