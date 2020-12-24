#EVENT MANAGER

#REQUIRES LIBRARIES NEEDED FOR THE PROJECT

#CSV ALLOWS US TO READ CSV FILES
require "csv"

#GOOGLE'S CIVIC API ALLOWS US TO ACCES THE NAMES OF LEGISLATORS
require 'google/apis/civicinfo_v2'

#ERB IS RUBYS OWN TEMPLATE LIBRARY
require 'erb'

#READING FORM LETTER FROM FILE SO THAT IT CAN BE USED LATER IN THE PROGRAM
#template_letter = File.read "form_letter.html"

#THIS METHOD ADJUSTS ZIPCODES INTO 5 DIGIT NUMBERS, AND ADDS 0S TO FILL THE 5 DIGIT LENGTH
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

#THIS METHOD WILL FIND THE LEGISLATORS OF A SPECIFIC ZIPCODE
#THROUGH THE USE OF GOOGLE'S CIVIC API
def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  
    begin
      civic_info.representative_info_by_address(
        address: zip, 
        levels: 'country', 
        roles: ['legislatorUpperBody', 'legislatorLowerBody', ]
      ).officials
       
      #legislators = legislators.officials
      #legislator_names = legislators.map(&:name)
      #legislators_string = legislator_names.join(", ")

      #USING THE RESCUE LOOP SO THAT THE CODE DOES NOT STOP WHEN AN ERROR OCCURS
    rescue
      "You can find your representatives by visiting link"
    end
end

#THIS METHOD IS FOR SAVING EACH THANK YOU LETTER CREATED INTO 
#A NEW FILE IN A FOLDER
def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts "EventManager Initialized!"

#READING CSV FILE USING CSV FOR LATER USE IN THE PROGRAM
#OPTIONS ADDED: 
  #- HEADERS
  #- HEADERS AS SYMBOLS
contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

#USING ERB FILE INSTEAD OF COMMON TEXT FILE TO AVOID SOME PROBLEMS
template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  #GSUB METHODS CHANGE VARIABLES IN A NORMAL TEXT FILE
  #personal_letter = template_letter.gsub('FIRST_NAME', name)
  #personal_letter.gsub!('LEGISLATORS', legislators)

  form_letter = erb_template.result(binding)
  save_thank_you_letter(id, form_letter)
end
