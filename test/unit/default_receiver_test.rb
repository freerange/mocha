# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'mocha/receivers'

class DefaultReceiverTest < Mocha::TestCase
  include Mocha

  def test_mocks_returns_mock
    mock = :mocha
    receiver = DefaultReceiver.new(mock)
    assert_equal [:mocha], receiver.mocks
  end
end
