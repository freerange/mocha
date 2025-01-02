# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class ArrayFlattenTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_flattens_array_containing_mock_which_responds_like_active_record_model
    model = Class.new do
      # Ref: https://github.com/rails/rails/blob/7db044f38594eb43e1d241cc82025155666cc6f1/activerecord/lib/active_record/core.rb#L734-L745
      def to_ary
        nil
      end
      private :to_ary
    end.new
    test_result = run_as_test do
      m = mock.responds_like(model)
      assert_equal [m], [m].flatten
    end
    assert_passed(test_result)
  end
end
