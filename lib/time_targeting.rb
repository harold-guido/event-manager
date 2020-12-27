#REQUIRES LIBRARIES NEEDED FOR THE PROJECT

#CSV ALLOWS US TO READ CSV FILES
require "csv"

#DATE ALLOWS ME TO CONVERT STRINGS INTO DATE OBJECTS
require "date"

def tabulate_frequency(hash, key)
  if hash.has_key?(key)
    hash[key] += 1
  else
    hash[key] = 1
  end
  hash
end

def sort_hash(hash)
  hash.sort_by {|key,value| value}.reverse!.to_h
end

puts "EventManager Initialized!"

#READING CSV FILE USING CSV FOR LATER USE IN THE PROGRAM
#OPTIONS ADDED: 
  #- HEADERS
  #- HEADERS AS SYMBOLS
contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

#USING ERB FILE INSTEAD OF COMMON TEXT FILE TO AVOID SOME PROBLEMS
template_letter = File.read "form_letter.erb"

hours_frequency = Hash.new
weekday_frequency = Hash.new

contents.each do |row|
  #USING DATETIME TO FIND THE HOUR OF REGISTRATION OF EACH PERSON
  hour_registered = DateTime.strptime(row[:regdate], '%m/%d/%y %H:%M').hour

  #USNG DATE TO FIND THE DAY OF THE WEEK OF REGISTRATION OF EACH PERSON
  weekday_registered = DateTime.strptime(row[:regdate], '%m/%d/%y %H:%M').wday

  #TABULATING HOUR FREQUENCY INTO A HASH
  hours_frequency = tabulate_frequency(hours_frequency, hour_registered)
  weekday_frequency = tabulate_frequency(weekday_frequency, weekday_registered)
end

puts sort_hash(hours_frequency)
puts sort_hash(weekday_frequency)
