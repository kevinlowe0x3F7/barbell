# !/usr/bin/ruby

require './Exercise.rb'
require './Workout.rb'
require './User.rb'
require './Template.rb'
require './colorize.rb'
# TODO Include option to remove help text in session for experienced users
# Public: Script that the user will use to create and save their workouts.
# The script uses a while loop and user input to process data. For usage
# guide, type 'ruby main.rb help' into the command line.

trap "SIGINT" do
  puts "Interrupted, no data in the session will be saved"
  exit 130
end

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
  puts "Welcome to Barbell Gem!"
  display_options(user)
  print "What would you like to do? "
  choice = stdin.gets.chomp
  choice.downcase!
  while true
    success = false
    case choice
    when '1', 'add'
      success = add_option(user, stdin)
      if success
        display_options(user)
        if user.more_help
          puts "Type 'exit' or 'quit' to exit at any time, or if you are done"
        end
        print "What else would you like to do? "
        choice = stdin.gets.chomp
        choice.downcase!
      else
        puts "Error with adding. Try again."
        display_options(user)
        print "What would you like to do? "
        choice = stdin.gets.chomp
        choice.downcase!
      end
    when '2', 'view'
      success = view_option(user, stdin)
      if success
        display_options(user)
        if user.more_help
          puts "Type 'exit' or 'quit' to exit at any time, or if you are done"
        end
        print "What else would you like to do? "
        choice = stdin.gets.chomp
        choice.downcase!
      else
        puts "Error with viewing. Try again."
        display_options(user)
        print "What would you like to do? "
        choice = stdin.gets.chomp
        choice.downcase!
      end
    when '3', 'delete'
      success = delete_option(user, stdin)
      if success
        display_options(user)
        if user.more_help
          puts "Type 'exit' or 'quit' to exit at any time, or if you are done"
        end
        print "What else would you like to do? "
        choice = stdin.gets.chomp
        choice.downcase!
      else
        puts "Error with deleting. Try again."
        display_options(user)
        print "What would you like to do? "
        choice = stdin.gets.chomp
        choice.downcase!
      end
    when 'exit', 'quit'
      User.serialize(user)
      return
    else
      puts "Please choose one of the above commands."
      print "What would you like to do? "
      choice = stdin.gets.chomp
      choice.downcase!
    end
  end
end

# Public: Display all possible user options.
#
# user - The current user
def display_options(user)
  options = ["Add", "View", "Delete"]
  option_num = 1
  options.each do |option|
    printf("%d. %s\n", option_num, option)
    option_num += 1
  end
  if user.more_help
    puts "For each option, you can type either the number of the option"\
      + ". Example: '1' or 'add' will both lead to the add command."
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
def add_option(user, stdin=$stdin)
  options = ["Workout", "Template", "Exercise"]
  option_num = 1
  options.each do |option|
    printf("%d. %s\n", option_num, option)
    option_num += 1
  end
  print "What would you like to add? "
  choice = stdin.gets.chomp
  choice.downcase!
  while true
    case choice
    when '1', 'workout'
      success = add_workout(user, stdin)
      if success
        print "Add another workout? (y or n) "
        add_another = stdin.gets.chomp
        add_another.downcase!
        if add_another == 'y' || add_another == 'yes'
          choice = '1'
        else
          return true
        end
      else
        return false
      end
    when '2', 'template'
      success = add_template(user, stdin)
      if success
        print "Add another template? (y or n) "
        add_another = stdin.gets.chomp
        add_another.downcase!
        if add_another == 'y' || add_another == 'yes'
          choice = '2'
        else
          return true
        end
      else
        return false
      end
    when '3', 'exercise'
      success = add_exercise_into_workout(user, stdin)
      if success
        print "Add another exercise in a workout? (y or n) "
        add_another = stdin.gets.chomp
        add_another.downcase!
        if add_another == 'y' || add_another == 'yes'
          choice = '3'
        else
          return true
        end
      else
        return false
      end
    when 'exit', 'quit'
      abort
    else
      print "Please choose one of the above options: "
      choice = stdin.gets.chomp
      choice.downcase!
    end
  end
end

# Public: Gives the user the option to view something, which can be a
# template that they entered, any workout, as well as an exercise in
# a graph form.
#
# user - The user which the information is coming from
#
# Returns true for a successful viewing, and false otherwise
def view_option(user, stdin=$stdin)
  options = ["Workout", "Template", "Exercise"]
  option_num = 1
  options.each do |option|
    printf("%d. %s\n", option_num, option)
    option_num += 1
  end
  print "What would you like to view? "
  choice = stdin.gets.chomp
  choice.downcase!
  while true
    case choice
    when '1', 'workout'
      success = view_workout(user, stdin)
      if success
        print "View another workout? (y or n) "
        view_another = stdin.gets.chomp
        view_another.downcase!
        if view_another == 'y' || view_another == 'yes'
          choice = '1'
        else
          return true
        end
      else
        return false
      end
    when '2', 'template'
      success = view_template(user, stdin)
      if success
        print "View another template? (y or n) "
        view_another = stdin.gets.chomp
        view_another.downcase!
        if view_another == 'y' || view_another == 'yes'
          choice = '2'
        else
          return true
        end
      else
        return false
      end
    when '3', 'exercise'
      success = view_exercise(user, stdin)
      if success
        print "View another exercise? (y or n) "
        view_another = stdin.gets.chomp
        view_another.downcase!
        if view_another == 'y' || view_another == 'yes'
          choice = '3'
        else
          return true
        end
      else
        return false
      end
    when 'exit', 'quit'
      abort
    else
      print "Please choose one of the above options: "
      choice = stdin.gets.chomp
      choice.downcase!
    end
  end
end

# Public: Grab user input to do a deletion, of either a workout or a
# template
#
# user - The user object that is modified
#
# Returns true for a successful deletion, false otherwise
def delete_option(user, stdin=$stdin)
  options = ["Workout", "Template"]
  option_num = 1
  options.each do |option|
    printf("%d. %s\n", option_num, option)
    option_num += 1
  end
  print "What would you like to view? "
  choice = stdin.gets.chomp
  choice.downcase!
  while true
    case choice
    when '1', 'workout'
      success = delete_workout(user, stdin)
      if success
        print "Delete another workout? (y or n) "
        delete_another = stdin.gets.chomp
        delete_another.downcase!
        if delete_another == 'y' || delete_another == 'yes'
          choice = '1'
        else
          return true
        end
      else
        return false
      end
    when '2', 'template'
      success = delete_template(user, stdin)
      if success
        print "Delete another template? (y or n) "
        delete_another = stdin.gets.chomp
        delete_another.downcase!
        if delete_another == 'y' || delete_another == 'yes'
          choice = '2'
        else
          return true
        end
      else
        return false
      end
    when 'exit', 'quit'
      abort
    else
      print "Please choose one of the above options: "
      choice = stdin.gets.chomp
      choice.downcase!
    end
  end
end

# Public: Grab user input for a workout, through either a template or
# through freeform entry.
#
# user - The user object that is modified
#
# Returns true for a successful workout add, and false otherwise
def add_workout(user, stdin=$stdin)
  print "Would you like to use a pre-defined template? "
  while true
    choice = stdin.gets.chomp
    choice.downcase!
    while true
      case choice
      when 'y', 'yes'
        if user.templates.length == 0
          puts "No templates for user"
          return false
        end
        template = ""
        while true
          puts "Choose a template"
          template_num = 1
          user.templates.each do |template|
            template_name = template.name.split.map(&:capitalize).join(' ')
            printf("%d. %s\n", template_num, template.name)
            template_num += 1
          end
          print "Template number: "
          template = stdin.gets.chomp
          template.downcase! 
          if is_i? template
            template_index = Integer(template, 10) - 1
            if template_index >= user.templates.length || template_index < 0
              puts "Number out of bounds"
              next
            else
              template = user.templates[template_index]
              break
            end
          elsif user.templates.include? template
            template_index = 0
            index = 0
            user.templates.each do |user_template|
              if user_template.eql? template
                template_index = index
                break
              end
            end
            template = user.templates[template_index]
            break
          else
            puts "Template not found"
          end
        end
        success = add_workout_with_template(user, template)
        return success
      when 'n', 'no'
        success = add_workout_freeform(user)
        return success
      when 'quit', 'exit'
        abort
      else
        print "Please choose yes (y) or no (n): "
        choice = stdin.gets.chomp
        choice.downcase!
      end
    end
  end
end

# Public: Ask user input for adding a workout with a template included
#
# user - The user that is being modified
# template - A list of exercises that will be used
#
# Returns true if workout is successfully added, and false otherwise.
def add_workout_with_template(user, template, stdin=$stdin)
  puts "Adding workout:"
  proper_template = template.name.split.map(&:capitalize).join(' ')
  workout = Workout.new(proper_template)
  wsrs = Array.new
  exercise_num = 0
  exercise_name = template.exercises[exercise_num]
  puts exercise_name.split.map(&:capitalize).join(' ')
  curr_exercise = Exercise.new(exercise_name)
  option = 'more'
  while !(option.eql? 'done')
    case option
    when 'more'
      wsrs << ask_for_wsr(stdin)
      if user.more_help
        puts "Type in 'more', 'next', or 'done'"
      end
      print "More sets, move to next exercise, or done with workout? "
      option = stdin.gets.chomp
      option.downcase!
    when 'next'
      wsrs.each { |wsr| curr_exercise.add_wsr(wsr.weight, wsr.sets, wsr.reps) }
      workout.add_exercise(curr_exercise)
      wsrs = Array.new
      exercise_num += 1
      if exercise_num >= template.exercises.length
        break
      end
      exercise_name = template.exercises[exercise_num]
      puts exercise_name.split.map(&:capitalize).join(' ')
      curr_exercise = Exercise.new(exercise_name)
      option = 'more'
    when 'exit', 'quit'
      abort
    else
      printf("%s is not a valid command", option)
      puts "More sets, move to next exercise, or done with workout?"
      option = stdin.gets.chomp
      option.downcase!
    end
  end
  if wsrs.length > 0
      wsrs.each { |wsr| curr_exercise.add_wsr(wsr.weight, wsr.sets, wsr.reps) }
      workout.add_exercise(curr_exercise)
  end
  if user.more_help
    puts "Enter 0 for today, otherwise go by integer values"
  end
  print "How many days ago was this workout? "
  days_ago = stdin.gets.chomp
  while !(is_i? days_ago)
    puts "Not a number, please input an integer"
    print "How many days ago was this workout? "
    days_ago = stdin.gets.chomp
  end
  workout.set_date(Integer(days_ago, 10))
  user.add_workout(workout)
  puts "Workout successfully added! User data saved"
  User.serialize(user)
  return true
end

# Public: Ask user input for adding a workout free form (no template).
# The primary difference between template and free form is that the
# free form version will ask for the name of the exercise.
#
# user - The user that is being modified
#
# Returns true if workout is sucessfully added, and false otherwise.
def add_workout_freeform(user, stdin=$stdin)
  puts "Adding workout:"
  workout = Workout.new
  wsrs = Array.new
  exercise_name = ask_for_exercise(stdin)
  puts exercise_name.split.map(&:capitalize).join(' ')
  curr_exercise = Exercise.new(exercise_name)
  option = 'more'
  while !(option.eql? 'done')
    case option
    when 'more'
      wsrs << ask_for_wsr(stdin)
      if user.more_help
        puts "Type in 'more', 'next', or 'done'"
      end
      print "More sets, move to next exercise, or done with workout? "
      option = stdin.gets.chomp
      option.downcase!
    when 'next'
      wsrs.each { |wsr| curr_exercise.add_wsr(wsr.weight, wsr.sets, wsr.reps) }
      wsrs = Array.new
      workout.add_exercise(curr_exercise)
      next_prompt = "What is the name of the next exercise? "
      exercise_name = ask_for_exercise(next_prompt, stdin)
      duplicate = false
      workout.exercises.each do |name, exercise|
        if name.to_s.eql? exercise_name
          puts "Exercise already entered"
          duplicate = true
          break
        end
      end
      if duplicate
        option = 'next'
        next
      end
      puts exercise_name.split.map(&:capitalize).join(' ')
      curr_exercise = Exercise.new(exercise_name)
      option = 'more'
    when 'exit', 'quit'
      abort
    else
      printf("%s is not a valid command\n", option)
      print "More sets, move to next exercise, or done with workout? "
      option = stdin.gets.chomp
      option.downcase!
    end
  end
  if wsrs.length > 0
    wsrs.each { |wsr| curr_exercise.add_wsr(wsr.weight, wsr.sets, wsr.reps) }
    workout.add_exercise(curr_exercise)
  end
  if user.more_help
    puts "Enter 0 for today, otherwise go by integer values"
  end
  print "How many days ago was this workout? "
  days_ago = stdin.gets.chomp
  while !(is_i? days_ago)
    puts "Not a number, please input an integer"
    print "How many days ago was this workout? "
    days_ago = stdin.gets.chomp
  end
  workout.set_date(Integer(days_ago, 10))
  user.add_workout(workout)
  puts "Workout successfully added! User data saved"
  User.serialize(user)
  return true
end

# Public: Asks a user for a weight, set, rep combination.
# 
# Returns the new WSR given by user input
def ask_for_wsr(stdin=$stdin)
  while true
    print("Enter weight performed (in lbs): ")
    weight = stdin.gets.chomp
    if weight.eql?('exit') || weight.eql?('quit')
      abort
    elsif !(is_i? weight)
      puts "Not a number, try again"
    else
      weight = Integer(weight, 10)
      break
    end
  end
  while true
    print("Enter # of sets: ")
    sets = stdin.gets.chomp
    if sets.eql?('exit') || sets.eql?('quit')
      abort
    elsif !(is_i? sets)
      puts "Not a number, try again"
    else
      sets = Integer(sets, 10)
      if sets == 0
        puts "Error: 0 sets"
      else
        break
      end
    end
  end
  while true
    print("Enter # of reps: ")
    reps = stdin.gets.chomp
    if reps.eql?('exit') || reps.eql?('quit')
      abort
    elsif !(is_i? reps)
      puts "Not a number, try again"
    else
      reps = Integer(reps, 10)
      if reps == 0
        puts "Error: 0 reps"
      else
        break
      end
    end
  end
  return WSR.new(weight, sets, reps)
end

# Public: Asks a user for an exercise name. Used in freeform workout add
# and for creating templates
#
# prompt - The prompt that appears when asking for the exercise.
#
# Returns the exercise name that the user gives
def ask_for_exercise(prompt='What is the name of the exercise? ',
                     stdin=$stdin)
  print prompt
  name = stdin.gets.chomp
  name.downcase!
  if name.eql?('exit') || name.eql?('quit')
    abort
  else
    return name
  end
end

# Public: Grab user input for a new template
#
# user - The user object that is modified
#
# Returns true for a successful workout add, and false otherwise
def add_template(user, stdin=$stdin)
  while true
    print "Name of the new template: "
    template_name = stdin.gets.chomp
    template_name.downcase!
    duplicate = false
    user.templates.each do |template|
      if template.name.eql? template_name
        duplicate = true
        break
      end
    end
    if duplicate
      puts "User already has this template name, please choose another"
    else
      break
    end
  end
  new_template = Template.new(template_name)
  choice = 'y'
  prompt = "What is the name of the exercise? "
  while !choice.eql?('n') && !choice.eql?('no')
    next_exercise = ask_for_exercise(prompt, stdin)
    if new_template.exercises.include? next_exercise
      puts "Exercise already in template"
    else
      new_template.add_exercise(next_exercise)
    end
    while true
      print "Add another exercise name (y or n)? "
      choice = stdin.gets.chomp
      choice.downcase!
      if choice.eql?('exit') || choice.eql?('quit')
        abort
      elsif !choice.eql?('y') && !choice.eql?('yes') && !choice.eql?('n')\
              && !choice.eql?('no')
        puts "Please select yes or no"
      else
        break
      end
    end
    prompt = "What is the name of the next exercise? "
  end
  user.add_template(new_template)
  puts "New template added! User data saved."
  User.serialize(user)
  return true
end

# Public: Adds an exercise into an existing workout, updating the workout.
#
# user - The user to be modified
#
# Returns true on a successful add, false otherwise
def add_exercise_into_workout(user, stdin=$stdin)
  if user.workouts.length == 0
    puts "No workouts to add an exercise into"
    return false
  end
  puts "Adding exercise:"
  workout = ask_for_workout(user, stdin)
  exercise_name = ask_for_exercise(stdin)
  exercise_to_add = Exercise.new(exercise_name)
  wsrs = Array.new
  option = 'more'
  while !option.eql?('done')
    case option
    when 'more'
      wsrs << ask_for_wsr(stdin)
      if user.more_help
        puts "Type in 'more' or 'done'"
      end
      print "More sets or done with entering? "
      option = stdin.gets.chomp
      option.downcase!
    when 'exit', 'quit'
      abort
    else
      printf("%s is not a valid command\n", option)
      print "More sets, move to next exercise, or done with workout? "
      option = stdin.gets.chomp
      option.downcase!
    end
  end
  wsrs.each { |wsr| exercise_to_add.add_wsr(wsr.weight, wsr.sets, wsr.reps) }
  workout.add_exercise(exercise_to_add)
  puts "Exercise successfully added! User data saved"
  User.serialize(user)
  return true
end

# Public: Get a workout from the user in the list of workouts. Asks the
# user for a number which is mapped to a workout. Separate function
# to avoid repeating
#
# user - The user to get the workout from
#
# Returns the workout given by the user, or nil if no workouts available
def ask_for_workout(user, stdin=$stdin)
  if user.workouts.length == 0
    return nil
  end
  num = 0
  limit = 2
  while true
    while num <= limit
      index = user.workouts.length - 1 - num
      if index < 0
        break
      end
      if num == limit
        printf("%d. Choose this number for less recent workouts\n", num)
      else
        workout_name = user.workouts[index].name
        workout_name = workout_name.split.map(&:capitalize).join(' ')
        printf("%d. %s\n", num, workout_name)
      end
      num += 1
    end
    if index < 0
      seen_range = [0, user.workouts.length - 1]
    else
      seen_range = [user.workouts.length - limit, user.workouts.length - 1]
    end
    num = limit
    index += 1
    print "Please choose (by index) a workout to add an exercise into: "
    choice = stdin.gets.chomp
    breakout = false
    while true
      if !(is_i? choice)
        puts "Not a number"
        print "Please choose (by index) a workout to add an exercise into: "
        choice = stdin.gets.chomp
      elsif choice.eql?('quit') || choice.eql?('exit')
        abort
      else
        num = Integer(choice, 10)
        real_index = user.workouts.length - 1 - num
        if real_index == user.workouts.length - 1 - limit
          limit += 10
          break
        elsif real_index < 0 || real_index >= user.workouts.length\
          || real_index < seen_range[0] || real_index > seen_range[1]
          puts "Number out of range"
          print "Please choose (by index) a workout to add an exercise into: "
          choice = stdin.gets.chomp
        else
          breakout = true
          break
        end
      end
    end
    if breakout
      break
    end
  end
  workout = user.workouts[real_index]
  return workout
end

# Public: Get a template from the user in the list of workouts. Asks the
# user for a number which is mapped to a template. Separate function
# to avoid repeating
#
# user - The user to get the template from
#
# Returns the template given by the user, or nil if no templates available
def ask_for_template(user, stdin=$stdin)
  if user.templates.length == 0
    return nil
  end
  num = 0
  limit = 2
  while true
    while num <= limit
      index = user.templates.length - 1 - num
      if index < 0
        break
      end
      if num == limit
        printf("%d. Choose this number for other templates\n", num);
      else
        template_name = user.templates[index].name
        template_name = template_name.split.map(&:capitalize).join(' ')
        printf("%d. %s\n", num, template_name)
      end
      num += 1
    end
    if index < 0
      seen_range = [0, user.templates.length - 1]
    else
      seen_range = [user.templates.length - limit, user.templates.length - 1]
    end
    num = limit
    index += 1
    print "Please choose (by index) a template "
    choice = stdin.gets.chomp
    breakout = false
    while true
      if !(is_i? choice)
        puts "Not a number"
        print "Please choose (by index) a template "
        choice = stdin.gets.chomp
      elsif choice.eql?('quit') || choice.eql?('exit')
        abort
      else
        num = Integer(choice, 10)
        real_index = user.templates.length - 1 - num
        if real_index == user.templates.length - 1 - limit
          limit += 10
          break
        elsif real_index < 0 || real_index >= user.templates.length\
          || real_index < seen_range[0] || real_index > seen_range[1]
          puts "Number out of range"
          print "Please choose (by index) a template "
          choice = stdin.gets.chomp
        else
          breakout = true
          break
        end
      end
    end
    if breakout
      break
    end
  end
  template = user.templates[real_index]
  return template
end

# Public: View a single workout.
#
# user - The user where the workout comes from
#
# Returns true on success, false otherwise
def view_workout(user, stdin=$stdin)
  if user.workouts.length == 0
    puts "No workouts available"
    return false
  end
  workout = ask_for_workout(user, stdin)
  puts workout.to_s
  return true
end

# Public: View a single template.
#
# user - The user where the template comes from
#
# Returns true on success, false otherwise
def view_template(user, stdin=$stdin)
  if user.templates.length == 0
    puts "No templates available"
    return false
  end
  template = ask_for_template(user, stdin)
  puts template.to_s
  return true
end

# Public: View a single exercise
#
# user - The user where the exercises are being extrapolated from
#
# Returns true on success, false otherwise
# TODO view_exercise method (false case could happen when exercise is not
# TODO found or if no workouts)
def view_exercise(user, stdin=$stdin)
  if !(Gem::Specification::find_all_by_name('gruf').any?)
    puts "Graphing dependency not found, please install it by using"\
      " the command 'gem install gruff'"
    return false
  end
  prompt = "What exercise do you want to view? "
  exercise_to_view = ask_for_exercise(prompt, stdin)
  
end

# Public: Delete a single workout
#
# user - The user object that is being modified
#
# Returns true on successful deletion, false otherwise
def delete_workout(user, stdin=$stdin)
  if user.workouts.length == 0
    puts "No workouts available"
    return false
  end
  workout = ask_for_workout(user, stdin)
  user.workouts.delete(workout)
  puts "Successfully deleted workout! User data saved"
  User.serialize(user)
  return true
end

# Public: Delete a single template
#
# user - The user object that is being modified
#
# Returns true on successful deletion, false otherwise
def delete_template(user, stdin=$stdin)
  if user.templates.length == 0
    puts "No templates available"
    return false
  end
  template = ask_for_template(user, stdin)
  user.templates.delete(template)
  puts "Successfully deleted template! User data saved"
  User.serialize(user)
  return true
end

# Public: Checks for whether a passed in string is made up of numbers
#
# str - The string that is being checked
#
# Returns true if str is made up of solely numbers, false otherwise.
def is_i?(str)
  /\A[-+]?\d+\z/ === str
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
