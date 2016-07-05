# !/usr/bin/ruby

require 'test/unit'
require 'stringio'
require './Exercise.rb'

class TestModels < Test::Unit::TestCase
  def setup
    @previous_stdout = $stdout
    $stdout = StringIO.new
    $stdout.rewind
  end

  def teardown
    $stdout = @previous_stdout
  end

  def test_exercise_and_wsr_adding
    bench = Exercise.new("Bench Press")
    assert_equal(0, bench.volume.size)
    assert_equal("bench press", bench.name)
    assert(bench.add_wsr(185,3,5))
    assert_equal(1, bench.volume.size)
    assert(bench.add_wsr(185,3,5))
    assert_equal(1, bench.volume.size)
    
    assert_equal("Bench Press\n185x3x5\n", bench.to_s)

    equal_wsr = WSR.new(185,3,5)
    bench.volume.each do |wsr|
      assert_equal("185x3x5", wsr.to_s)
      assert(wsr.eql? equal_wsr)
    end
    
    assert(!(bench.add_wsr(-20,3,5)))
    assert_equal("Negative number in entry\n", $stdout.string)

    assert(bench.add_wsr(225,1,5))
    assert_equal(2, bench.volume.size)
    assert_equal("Bench Press\n225x1x5\n185x3x5\n", bench.to_s)
  end
  
  def test_exercise_and_wsr_deleting
    squat = Exercise.new("SQUAT")
    assert_equal("squat", squat.name)
    assert(squat.add_wsr(225,3,10))
    assert(!(squat.add_wsr(225,3,-1)))
    assert_equal("Negative number in entry\n", $stdout.string)
    assert_equal(1, squat.volume.size)
    assert(squat.add_wsr(185,3,5))
    assert(squat.add_wsr(165,1,5))
    assert_equal(3, squat.volume.size)

    assert(squat.remove_wsr(185,3,5))
    assert_equal(2, squat.volume.size)
    assert(!(squat.remove_wsr(165,2,5)))
    assert_equal("Negative number in entry\n"\
                 + "Could not find 165x2x5 in exercise\n", $stdout.string)
    assert(squat.remove_wsr(165,1,5))
    assert_equal(1, squat.volume.size)

    equal_wsr = WSR.new(225,3,10)
    squat.volume.each do |wsr|
      assert_equal("225x3x10", wsr.to_s)
      assert(wsr.eql? equal_wsr)
    end
  end    
end
