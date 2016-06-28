# !/usr/bin/ruby
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

  # Public: Initializes the workout, setting the date based on how many
  # days ago the workout occured, and with exercises as empty.
  #
  # days_ago - The number of days that have passed since the user did
  # the workout in order to set the workout to the correct day
  #
  # TODO include assertion during user input that days_ago is an int
  def initialize(days_ago)
    @date = Time.now - (days_ago * SECONDS_IN_DAY)
    @exercises = Hash.new
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
end
