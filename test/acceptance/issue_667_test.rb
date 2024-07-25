require File.expand_path('../acceptance_test_helper', __FILE__)

class Issue665Test < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_expects_subset_of_parameters
    test_result = run_as_test do
      mock = mock()
      mock
        .expects(:method)
        .with(
          "test",
          hello: "world",
          goodbye: "world"
        )
      mock.method(
        "test",
        hello: "world",
        goodbye: "world",
        hello_again: "world"
      )
    end
    assert_passed(test_result)
  end
end
