# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)
require 'mocha/mockery'

class MockeryNeverSetupTest < Mocha::TestCase
  include Mocha

  def test_should_raise_not_initialized_error
    Mockery.instance_variable_set(:@instances, nil)
    assert_raises(NotInitializedError) do
      Mockery.teardown
    end
  end
end
