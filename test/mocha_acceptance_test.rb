require 'test_helper'
require 'mocha/mocha'

class MochaAcceptanceTest < Test::Unit::TestCase
  
  class Rover

    def initialize(left_track, right_track, steps_per_metre, steps_per_degree)
      @left_track, @right_track, @steps_per_metre, @steps_per_degree = left_track, right_track, steps_per_metre, steps_per_degree
    end

    def forward(metres)
      @left_track.move(metres * @steps_per_metre)
      @right_track.move(metres * @steps_per_metre)
      wait
    end

    def backward(metres)
      forward(-metres)
    end
    
    def left(degrees)
      @left_track.move(-degrees * @steps_per_degree)
      @right_track.move(+degrees * @steps_per_degree)
      wait
    end
    
    def right(degrees)
      left(-degrees)
    end
    
    def wait
      while (@left_track.moving? or @right_track.moving?); end
    end

  end

  def test_should_move_both_tracks_forward_ten_steps
    left_track = Mocha.new
    right_track = Mocha.new
    steps_per_metre = 5
    rover = Rover.new(left_track, right_track, steps_per_metre, nil)
    
    left_track.expects(:move).with(10)
    right_track.expects(:move).with(10)
    
    left_track.stubs(:moving?).returns(false)
    right_track.stubs(:moving?).returns(false)
    
    rover.forward(2)
    
    left_track.verify
    right_track.verify
  end
  
  def test_should_move_both_tracks_backward_ten_steps
    left_track = Mocha.new
    right_track = Mocha.new
    steps_per_metre = 5
    rover = Rover.new(left_track, right_track, steps_per_metre, nil)
    
    left_track.expects(:move).with(-10)
    right_track.expects(:move).with(-10)
    
    left_track.stubs(:moving?).returns(false)
    right_track.stubs(:moving?).returns(false)
    
    rover.backward(2)
    
    left_track.verify
    right_track.verify
  end
  
  def test_should_move_left_track_forwards_five_steps_and_right_track_backwards_five_steps
    left_track = Mocha.new
    right_track = Mocha.new
    steps_per_degree = 5.0 / 90.0
    rover = Rover.new(left_track, right_track, nil, steps_per_degree)
    
    left_track.expects(:move).with(+5)
    right_track.expects(:move).with(-5)
    
    left_track.stubs(:moving?).returns(false)
    right_track.stubs(:moving?).returns(false)
    
    rover.right(90)
    
    left_track.verify
    right_track.verify
  end
  
  def test_should_move_left_track_backwards_five_steps_and_right_track_forwards_five_steps
    left_track = Mocha.new
    right_track = Mocha.new
    steps_per_degree = 5.0 / 90.0
    rover = Rover.new(left_track, right_track, nil, steps_per_degree)
    
    left_track.expects(:move).with(-5)
    right_track.expects(:move).with(+5)
    
    left_track.stubs(:moving?).returns(false)
    right_track.stubs(:moving?).returns(false)
    
    rover.left(90)
    
    left_track.verify
    right_track.verify
  end
  
end