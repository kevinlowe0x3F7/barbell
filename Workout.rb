# !/usr/bin/ruby
# Public: Class containing information on a single workout.
class Workout
  # Public: The number of seconds in a day in order to calculate the
  # correct workout day
  SECONDS_IN_DAY = 86400

  # Public: Returns the date that the workout occurred.
  attr_reader :date
  # Public: Returns the list of exercises that the user did
  attr_reader :exercises

  # Public: Initializes the workout, setting the date as the date that this
  # object is created and with exercises as empty
  def initialize
    @date = Time.now
    @exercises = Array.new
  end

  # Public: Initializes the workout, setting the date based on how many
  # days ago the workout occured, and with exercises as empty.
  def initialize(days_ago)
    @date = Time.now - (days_ago * SECONDS_IN_DAY)
    @exercises = Array.new
  end
end
