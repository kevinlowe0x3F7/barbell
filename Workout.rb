# !/usr/bin/ruby

require './Exercise.rb'
# Public: Class containing information on a single workout.
class Workout
  # Public: The number of seconds in a day in order to calculate the
  # correct workout day
  SECONDS_IN_DAY = 86400

  # Public: The date that the workout occurred.
  attr_reader :date
  # Public: The set of exercises that the user did. Each exercise is a
  # dictionary entry with the form: name of exercise => Exercise object
  attr_reader :exercises
  # Public: The name of the workout. By default it will be 'Workout'
  # combined with the date that the workout is created. If a template
  # is used, it will be the name of the template plus the date.
  attr_reader :name

  # Public: Initializes the workout, setting the date as the date that this
  # object is created and with exercises as empty
  def initialize(name="Workout")
    @date = Time.now
    @exercises = Hash.new
    @name = "#{name} #{@date.strftime("%m-%d-%Y")}"
  end

  # Public: Sets the day of the workout if the data inputted was not
  # on the day of the actual workout. Calculates this by subtracting
  # days from the current time
  #
  # days_ago - The number of days that have passed since the user did
  # the workout in order to set the workout to the correct day
  #
  # TODO Include asking about days ago in parsing
  # Returns true if successful date switch, false otherwise.
  def set_date(days_ago)
    if !(days_ago.is_a? Integer)
      puts "Error in calculating date."
      return false
    end
    @date = Time.now - (days_ago * SECONDS_IN_DAY)
    @name = "#{name[0, name.rindex(' ')]} #{@date.strftime("%m-%d-%Y")}"
    return true
  end

  # Public: Adds a new exercise into the set of exercises
  #
  # exercise - The exercise to add into the set
  #
  # Returns true if the exercise is successfully added, false otherwise
  def add_exercise(exercise)
    if exercise.nil? || !(exercise.respond_to? 'add_wsr')
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
    if exercise_name.nil?
      puts "Null argument for exercise name"
      return false
    end
    exercise_name.downcase!
    if !(@exercises.key? exercise_name.to_sym)
      puts "Exercise not found"
      return false
    else
      @exercises.delete(exercise_name.to_sym)
      return true
    end
  end

  # Public: Modifies an exercise from the workout by manipulating
  # a single WSR in the exercise. The WSR in question must be specific
  # and precise because a contains check is used for modification.
  # This does not add or delete an entire exercise.
  #
  # exercise_name - The name of the exercise to be modified
  # weight - The weight of the WSR for modification
  # sets - The # of sets of the WSR for modification
  # reps - The # of reps of the WSR for modification
  # option - Whether one is trying to add a new WSR or delete, given
  #          as a String: "add" or "delete"
  # 
  # Returns true if the modification was successful, false otherwise
  def modify_exercise(exercise_name, weight, sets, reps, option)
    if exercise_name.nil? || option.nil?
      puts "Null argument"
      return false
    end
    exercise_name.downcase!
    if !(@exercises.key? exercise_name.to_sym)
      return false
    end
    exercise = @exercises[exercise_name.to_sym]
    if option.eql? "add"
      is_success = exercise.add_wsr(weight, sets, reps)
      return is_success
    elsif option.eql? "delete"
      is_success = exercise.remove_wsr(weight, sets, reps)
      return is_success
    else
      puts "Invalid option"
      return false
    end
  end

  # Public: The string representation for the workout, including each
  # exercise one by one
  def to_s
    result = ""
    @exercises.each { |name, exercise| result << exercise.to_s }
    return result
  end
end
