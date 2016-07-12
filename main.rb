# !/usr/bin/ruby

require './Exercise.rb'
require './Workout.rb'
require './User.rb'
require './Template.rb'
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

# Public: Parses the user's input and calls the appropriate function
# based on the input.
def parse_input
  puts "in parse_input"
end

# Public: Displays the help text (user guide) for this program.
def help
  puts "help text"
end

if __FILE__ == $0
  args = ARGV
  if args[0] == 'help' || args[0] == '?'
    help
  elsif args[0] == 'init' || args[0] == 'initialize'
    init
  elsif !(File.exist? '.fitness')
    puts "Data files not initialized, please type 'ruby main.rb init'"\
      + " before trying any other commands"
  else
    parse_input
  end
end
