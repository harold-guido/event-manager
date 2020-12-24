#EVENT MANAGER

#REQUIRES LIBRARIES NEEDED FOR THE PROJECT

#CSV ALLOWS US TO READ CSV FILES
require "csv"

def clean_phone(number)
  strip_number = number.split("").map { |num|
    if num != "0" && num.to_i == 0 
      ""
    else
      num
    end
  }.join("")
  if strip_number.length < 10 || strip_number.length > 11 
    return "No available number"
  elsif strip_number.length == 11 && strip_number[0] != "1"
    return "No available number"
  elsif strip_number.length == 11
    return strip_number[1..]
  else
    return strip_number
  end
end

#READING FORM LETTER FROM FILE SO THAT IT CAN BE USED LATER IN THE PROGRAM

#READING CSV FILE USING CSV FOR LATER USE IN THE PROGRAM
#OPTIONS ADDED: 
  #- HEADERS
  #- HEADERS AS SYMBOLS
contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
  name = row[:first_name]
  home_phone = clean_phone(row[:homephone])
  #home_phone = row[:homephone]

  puts "Name: #{name}, Home Phone: #{home_phone} "
end
