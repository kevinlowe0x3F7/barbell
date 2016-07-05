# !/usr/bin/ruby

require './Template.rb'
require './Workout.rb'
# Public: Information on the user, such as the templates that they have
# as well as all the workouts that they have saved. When a user is created,
# all the hidden metadata files are created along with it. There can only
# be one user per working directory.
class User
  # Public: The templates that the user has
  attr_accessor :templates
  # Public: Every workout that the user has completed. It is saved
  # as a list to preserve the ordering of workouts.
  attr_accessor :workouts

  # Public: Initializes a user, creating the metadata files for the user.
  # At this point, it is assumed that there is no other .fitness metadata
  # file so that it can be created freely without worry of overwrite.
  # TODO Include check of .fitness file in main
  def initialize
    @templates = Array.new
    @workouts = Array.new
    Dir.mkdir('.fitness')
  end

  # Public: Serializes a given user using Marshal. The file will be stored
  # in user.so inside the .fitness metadata file.
  #
  # user - The user to be serialized.
  #
  # Returns true if successful, false otherwise
  def self.serialize(user)
    if !(user.respond_to? 'add_template')
      puts "user is not a User object"
      return false
    end
    File.open('./.fitness/user.so', 'w') { |f| f.write(Marshal.dump(user)) }
    return true
  end

  # Public: Deserializes the user.so object using Marshal.
  #
  # Returns the User object found in user.so, or nil if it doesn't exist
  def self.deserialize
    if !(File.exist? './.fitness/user.so')
      puts "Serialized user object does not exist"
      return nil
    end
    user = Marshal.load(File.new('./.fitness/user.so', 'r'))
    return user
  end

  # Public: Add a template for the user
  #
  # template - The template to be added
  #
  # Returns true for a successful add, false otherwise.
  def add_template(template)
    if !(template.respond_to? 'add_exercise')
      puts "Error in adding template"
      return false
    else
      @templates.each do |t|
        if t.name.eql? template.name
          puts "Template name: #{template.name} already present"
          return false
        end
      end
      @templates << template
      return true
    end
  end

  # Public: Add a workout for the user
  #
  # workout - The workout to be added
  #
  # Returns true for a successful add, false otherwise
  def add_workout(workout)
    if !(workout.respond_to? 'set_date')
      puts "Error in adding workout"
      return false
    else
      @workouts << workout
      return true
    end
  end

  # Public: Delete a template based on the name
  #
  # Returns true for a successful deletion, false otherwise
  def delete_template(template_name)
    @templates.each do |t|
      if t.name.eql? template_name
        @templates.delete(t)
        return true
      end
    end
    puts "Template not found"
    return false
  end

  # Public: Delete a workout based on the index in the list.
  #
  # index - The index for the workout to be deleted
  #
  # Returns true for a successful deletion, false otherwise
  def delete_workout(index)
    result = @worouts.delete_at(index)
    if result.nil?
      puts "Workout not found"
      return false
    else
      return true
    end
  end
end
