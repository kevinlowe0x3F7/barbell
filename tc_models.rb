# !/usr/bin/ruby

require 'test/unit'
require 'stringio'
require './Exercise.rb'
require './Workout.rb'

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
                 + "Could not find 165x2x5 in squat\n", $stdout.string)
    assert(squat.remove_wsr(165,1,5))
    assert_equal(1, squat.volume.size)

    equal_wsr = WSR.new(225,3,10)
    squat.volume.each do |wsr|
      assert_equal("225x3x10", wsr.to_s)
      assert(wsr.eql? equal_wsr)
    end
  end

  def test_workout_creation
    workout1 = Workout.new("Workout A")
    date = Time.now
    assert_equal("Workout A #{date.strftime("%m-%d-%Y")}", workout1.name)
    workout1.set_date(3)
    date -= (3 * 86400)
    assert_equal("Workout A #{date.strftime("%m-%d-%Y")}", workout1.name)
    assert_equal(0, workout1.exercises.size)
  end
    
  def test_workout_adding_and_deleting
    workout1 = Workout.new("Workout A")
    squat = Exercise.new("Squat")
    squat.add_wsr(185,3,5)

    bench = Exercise.new("Bench")
    bench.add_wsr(155,3,5)

    rows = Exercise.new("Bent-over row")
    rows.add_wsr(145,3,5)

    assert(workout1.add_exercise(squat))
    assert(workout1.add_exercise(bench))
    assert(workout1.add_exercise(rows))
    assert(!(workout1.add_exercise(nil)))
    assert_equal("Error in entering exercise\n", $stdout.string)
    $stdout.reopen("")

    assert_equal(workout1.exercises[:squat], squat)
    assert_equal(workout1.exercises[:bench], bench)
    assert_equal(workout1.exercises[:"bent-over row"], rows)

    assert(workout1.delete_exercise("SQUAT"))
    assert(!(workout1.exercises.include? :squat))
    assert_equal(2, workout1.exercises.size)

    assert(!(workout1.delete_exercise("deadlift")))
    assert_equal("Exercise not found\n", $stdout.string)
    $stdout.reopen("")
    assert(!(workout1.delete_exercise(nil)))
    assert_equal("Null argument for exercise name\n", $stdout.string)
  end

  def test_workout_modifying
    workout1 = Workout.new("Workout B")
    squat = Exercise.new("Squat")
    squat.add_wsr(225,5,5)

    overhead = Exercise.new("overhead press")
    overhead.add_wsr(135,3,5)

    deadlift = Exercise.new("deadlift")
    deadlift.add_wsr(275,3,5)

    assert(workout1.add_exercise(squat))
    assert(workout1.add_exercise(overhead))
    assert(workout1.add_exercise(deadlift))

    assert(!(workout1.modify_exercise("overheadpress", 155, 3, 5, 'add')))
    assert(workout1.modify_exercise("squat", 235, 3, 5, 'add'))
    assert(!(workout1.modify_exercise("squat", 225, 4, 5, 'delete')))
    assert_equal("Could not find 225x4x5 in squat\n", $stdout.string)
    $stdout.reopen("")
    assert(workout1.modify_exercise("squat", 225, 5, 5, 'delete'))
    
    assert(workout1.modify_exercise("deadlift", 275, 3, 5, 'delete'))
    assert(workout1.modify_exercise("deadlift", 275, 1, 5, 'add'))
  end
end
