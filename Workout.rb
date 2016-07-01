# !/usr/bin/ruby
# TODO Implement ability to change an exercise's weight/sets/reps given name
# Public: Class containing information on a single workout.
class Workout
  # Public: The number of seconds in a day in order to calculate the
  # correct workout day
  SECONDS_IN_DAY = 86400

  # Public: The date that the workout occurred.
  attr_reader :date
  # Public: The set of exercises that the user did. Each exercise is a
  #         dictionary entry with the form:
  #         :name of exercise => Exercise object
  attr_reader :exercises

  # Public: Initializes the workout, setting the date as the date that this
  # object is created and with exercises as empty
  def initialize
    @date = Time.now
    @exercises = Hash.new
  end

  # Public: Sets the day of the workout if the data inputted was not
  # on the day of the actual workout. Calculates this by subtracting
  # days from the current time
  #
  # days_ago - The number of days that have passed since the user did
  # the workout in order to set the workout to the correct day
  #
  # Returns true if successful date switch, false otherwise.
  def set_date(days_ago)
    if !(days_ago is_a? Integer)
      puts "Error in calculating date."
      return false
    @date = Time.now - (days_ago * SECONDS_IN_DAY)
    return true
  end

  # Public: Adds a new exercise into the set of exercises
  #
  # exercise - The exercise to add into the set
  #
  # Returns true if the exercise is successfully added, false otherwise
  def add_exercise(exercise)
    if exercise.nil? || !(exercise.is_a? Exercise)
      puts "Error in entering exercise" 
      return false
    end
    @exercises[exercise.name.to_sym] = exercise
    return true
  end

  # Public: Deletes a given exercise from the workout
  #
  # exercise_name - The name of the exercise to be deleted
  #
  # Returns true if the exercise is successfully deleted, false otherwise
  def delete_exercise(exercise_name)
    exercise_name.downcase!
    if !(@exercises.key? exercise_name.to_sym)
      return false
    else
      @exercises.delete(exercise_name.to_sym)
      return true
    end
  end
end
