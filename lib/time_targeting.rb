#REQUIRES LIBRARIES NEEDED FOR THE PROJECT

#CSV ALLOWS US TO READ CSV FILES
require "csv"

#DATE ALLOWS ME TO CONVERT STRINGS INTO DATE OBJECTS
require "date"

def collect_reg_hours(date)
  hours = []
  hours.push(DateTime.strptime(date, '%m/%d/%y %H:%M'))
  hours
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

contents.each do |row|
  hour_registered = DateTime.strptime(row[:regdate], '%m/%d/%y %H:%M').hour

  if hours_frequency.has_key?(hour_registered)
    hours_frequency[hour_registered] += 1
  else
    hours_frequency[hour_registered] = 1
  end
end

puts hours_frequency.sort_by { |hour, frequency| frequency}.reverse!.to_h
