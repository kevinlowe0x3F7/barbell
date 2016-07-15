# !/usr/bin/ruby

require './Exercise.rb'
require './Workout.rb'
require './User.rb'
require './Template.rb'
# TODO Include option to remove help text in session for experienced users
# Public: Script that the user will use to create and save their workouts.
# The script uses a while loop and user input to process data. For usage
# guide, type 'ruby main.rb help' into the command line.

# Public: Initializes this program by creating the .fitness folder and
# setting up any other necessary metadata files
# Returns true for successful initialization, and false otherwise
def init
  if File.exist? '.fitness'
    puts "Data files already initialized"
    return false
  else
    user = User.new
    User.serialize(user)
  end
end

# Public: Starts a user session to manipulate or view their entered data
# TODO Add case for if command doesn't exist
# TODO Add interrupt issue
def start(stdin=$stdin)
  begin
    user = User.deserialize
    if user.nil?
      return
    end
  rescue
    puts "Error loading user object. Check to see if '.fitness' dir "\
      + "exists, otherwise considering restarting."
  end
  puts "Welcome! What would you like to do?"
  options = ["Add"]
  option_num = 1
  options.each do |option|
    printf("%d. %s\n", option_num, option)
    option_num += 1
  end
  if user.more_help
    puts "For each option, you can type either the number of the option"\
      + ". Example: '1' or 'add' will both lead to the add command."
  end
  while true
    choice = stdin.gets.chomp
    choice.downcase!
    success = false
    case choice
    when '1', 'add'
      success = add_option(user)
    when 'exit', 'quit'
      return
    end
  end
end

# Public: This method is called when the user wants to add something.
# It could be a workout, template, or exercise from a specific workout.
# User input will continue to be gathered here
#
# user - The user object that is modified
#
# Returns true if the user adds one or more things without any errors,
# and false otherwise.
# TODO implement getting user input for each add operation
# TODO be able to handle multiple adds inside this one function
def add_option(user)
  puts "What would you like to add?"
  options = ["Workout", "Template", "Exercise"]
  option_num = 1
  options.each do |option|
    printf("%d. %s\n", option_num, option)
    option_num += 1
  end
  choice = stdin.gets.chomp
  choice.downcase!
  case choice
  when '1', 'workout'
    puts "adding workout"
  when '2', 'template'
    puts "adding template"
  when '3', 'exercise'
    puts "adding exercise"
  when 'exit', 'quit'
    abort
  end
end
# Public: Displays the help text (user guide) for this program.
def help
  puts "help text"
end

if __FILE__ == $0
  args = ARGV
  if args.length == 0
    puts "No arguments given, try 'ruby main.rb help' for guidance"
  elsif args[0] == 'help' || args[0] == '?'
    help
  elsif args[0] == 'init' || args[0] == 'initialize'
    init
  elsif args[0] == 'start'
    if !(File.exist? '.fitness')
      puts "Data files not initialized, please type 'ruby main.rb init'"\
        + " before starting"
    else
      start
    end
  else
    puts "Not a proper command, try 'ruby main.rb help' for guidance"
  end
end