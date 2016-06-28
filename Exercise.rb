# !/usr/bin/ruby
# Public: Class containing information on one individual workout.
class Exercise
  # Public: The name of the exercise.
  attr_accessor :name
  # Public: A list of WSRs for the exercise.
  attr_accessor :volume
end

# Public: A WSR is a container of information for some exercise, where WSR
# is an acronym for Weight, Sets, Reps. The idea is that a single named
# exercise can have multiple WSRs, (i.e. a lifter could do 185 lbs for 1 set
# for 5 reps and then 165 for 2 sets for 5 reps) 
# TODO eventually: include feature for RPE
class WSR
  # Public: The amount of weight done, 0 indicating bodyweight.
  attr_accessor :weight
  # Public: The number of sets done.
  attr_accessor :sets
  # Public: The number of reps completed.
  attr_accessor :reps

  # Public: Initialize a WSR with given variables to set.
  #
  # weight - The weight that the user performed the exercise with
  # sets - The number of sets performed at this weight
  # reps - The number of reps for each set
  def initialize(weight, sets, reps)
    @weight = weight
    @sets = sets
    @reps = reps
  end
end
