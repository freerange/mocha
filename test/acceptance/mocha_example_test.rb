# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class MochaExampleTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  class Rover
    def initialize(left_track, right_track, steps_per_metre, steps_per_degree)
      @left_track = left_track
      @right_track = right_track
      @steps_per_metre = steps_per_metre
      @steps_per_degree = steps_per_degree
    end

    def forward(metres)
      @left_track.step(metres * @steps_per_metre)
      @right_track.step(metres * @steps_per_metre)
      wait
    end

    def backward(metres)
      forward(-metres)
    end

    def left(degrees)
      @left_track.step(-degrees * @steps_per_degree)
      @right_track.step(+degrees * @steps_per_degree)
      wait
    end

    def right(degrees)
      left(-degrees)
    end

    def wait
      while @left_track.moving? || @right_track.moving?; end
    end
  end

  def test_should_step_both_tracks_forward_ten_steps
    left_track = mock('left_track')
    right_track = mock('right_track')
    steps_per_metre = 5
    rover = Rover.new(left_track, right_track, steps_per_metre, nil)

    left_track.expects(:step).with(10)
    right_track.expects(:step).with(10)

    left_track.stubs(:moving?).returns(false)
    right_track.stubs(:moving?).returns(false)

    rover.forward(2)
  end

  def test_should_step_both_tracks_backward_ten_steps
    left_track = mock('left_track')
    right_track = mock('right_track')
    steps_per_metre = 5
    rover = Rover.new(left_track, right_track, steps_per_metre, nil)

    left_track.expects(:step).with(-10)
    right_track.expects(:step).with(-10)

    left_track.stubs(:moving?).returns(false)
    right_track.stubs(:moving?).returns(false)

    rover.backward(2)
  end

  def test_should_step_left_track_forwards_five_steps_and_right_track_backwards_five_steps
    left_track = mock('left_track')
    right_track = mock('right_track')
    steps_per_degree = 5.0 / 90.0
    rover = Rover.new(left_track, right_track, nil, steps_per_degree)

    left_track.expects(:step).with(+5)
    right_track.expects(:step).with(-5)

    left_track.stubs(:moving?).returns(false)
    right_track.stubs(:moving?).returns(false)

    rover.right(90)
  end

  def test_should_step_left_track_backwards_five_steps_and_right_track_forwards_five_steps
    left_track = mock('left_track')
    right_track = mock('right_track')
    steps_per_degree = 5.0 / 90.0
    rover = Rover.new(left_track, right_track, nil, steps_per_degree)

    left_track.expects(:step).with(-5)
    right_track.expects(:step).with(+5)

    left_track.stubs(:moving?).returns(false)
    right_track.stubs(:moving?).returns(false)

    rover.left(90)
  end
end
