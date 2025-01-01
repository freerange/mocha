# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

require 'mocha/minitest'
require 'integration/shared_tests'

class MinitestTest < Mocha::TestCase
  include SharedTests
end
