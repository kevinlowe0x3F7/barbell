# !/usr/bin/ruby

require 'set'
# Public: Class containing information on one individual workout.
# TODO Save data for personal record
class Exercise
  # Public: The name of the exercise.
  attr_accessor :name
  # Public: A list of WSRs for the exercise.
  attr_accessor :volume

  # Public: Initialize an exercise with a given name
  #
  # name - The given name of the exercise. Lowercased for consistency
  def initialize(name)
    @name = name.downcase
    @volume = Set.new
  end

  # Public: Add a WSR into the list
  #
  # weight - The weight performed
  # sets - The number of sets performed with this weight
  # reps - The number of reps for each set
  #
  # Returns true if successfully added, false otherwise
  def add_wsr(weight, sets, reps)
    if weight < 0 || sets < 0 || reps < 0
      puts "Negative number in entry"
      return false
    end
    volume.add(WSR.new(weight, sets, reps))
    return true
  end

  # Public: Delete a WSR that contains the respective information.
  #
  # weight - The weight for the WSR to be deleted
  # sets - The number of sets for the WSR to be deleted
  # reps - The number of reps for the WSR to be deleted
  #
  # Returns true if the removal was successful, false otherwise
  def remove_wsr(weight, sets, reps)
    wsr_to_check = WSR.new(weight, sets, reps)
    if @volume.include? wsr_to_check
      @volume.delete(wsr_to_check)
      return true
    else
      puts "Could not find #{weight}x#{sets}x#{reps} in #{@name}"
      return false
    end
  end

  # Public: The string representation for the exercise, given by its name
  # in capitals followed by each WSR on a new line.
  def to_s
    result = name.split.map(&:capitalize).join(' ')
    result << "\n"
    sorted_weight = @volume.to_a.sort_by { |wsr| wsr.weight }.reverse!
    sorted_weight.each do |wsr|
      result << wsr.to_s
      result << "\n"
    end
    return result
  end
end

# Public: A WSR is a container of information for some exercise, where WSR
# is an acronym for Weight, Sets, Reps. The idea is that a single named
# exercise can have multiple WSRs, (i.e. a lifter could do 185 lbs for 1 set
# for 5 reps and then 165 for 2 sets for 5 reps) 
# TODO eventually: include feature for RPE
class WSR
  # Public: The amount of weight done, 0 indicating bodyweight.
  attr_reader :weight
  # Public: The number of sets done.
  attr_reader :sets
  # Public: The number of reps completed.
  attr_reader :reps

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

  # Public: Hash method in order to add this item into a Set
  def hash
    return @weight + @sets + @reps
  end

  # Public: The equals method, where two WSRs are defined as equal iff
  # they have the same weight, sets, and reps numbers.
  def eql?(other)
    return self.class === other && @weight == other.weight &&
      @sets == other.sets && @reps == other.reps
  end

  # Public: The string representation of the WSR
  def to_s
    return "#{@weight}x#{@sets}x#{@reps}"
  end
end
