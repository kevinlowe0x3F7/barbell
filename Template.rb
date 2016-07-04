# !/usr/bin/ruby

# Public: An abstraction of a workout template which contains a list
# of exercises for easy reference.
class Template
  # Public: A name to reference the template
  attr_accessor :name
  # Public: The list of exercises in this template
  attr_accessor :exercises

  # Public: Initializes a template with a given name
  #
  # name - The name to use for this template. Lowercased for consistency
  def initialize(name)
    @name = name
    @exercises = Array.new
  end

  # Public: Add an exercise into the template, given by a String.
  #
  # name - The name of the exercise to be added
  #
  # Returns true if successful, false otherwise
  def add_exercise(name)
    if !(name.respond_to? 'downcase')
      puts "Error with name, please make sure it is a String."
      return false
    end
    name.downcase!
    if @exercises.include? name
      puts "Name already in template"
      return false
    else
      @exercises << name
      return true
    end
  end
end
