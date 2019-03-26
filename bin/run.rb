require_relative '../config/environment'
require 'pry'

puts "                            ..,,,,,,,,,.. 
                     .,;%%%%%%%%%%%%%%%%%%%%;,. 
                   %%%%%%%%%%%%%%%%%%%%////%%%%%%, .,;%%;, 
            .,;%/,%%%%%/////%%%%%%%%%%%%%%////%%%%,%%//%%%, 
        .,;%%%%/,%%%///%%%%%%%%%%%%%%%%%%%%%%%%%%%%,////%%%%;, 
     .,%%%%%%//,%%%%%%%%%%%%%%%%@@%a%%%%%%%%%%%%%%%%,%%/%%%%%%%;, 
   .,%//%%%%//,%%%%///////%%%%%%%@@@%%%%%%///////%%%%,%%//%%%%%%%%, 
 ,%%%%%///%%//,%%//%%%%%///%%%%%@@@%%%%%////%%%%%%%%%,/%%%%%%%%%%%%% 
.%%%%%%%%%////,%%%%%%%//%///%%%%@@@@%%%////%%/////%%%,/;%%%%%%%%/%%% 
%/%%%%%%%/////,%%%%///%%////%%%@@@@@%%%///%%/%%%%%//%,////%%%%//%%%' 
%//%%%%%//////,%/%a`  'a%///%%%@@@@@@%%////a`  'a%%%%,//%///%/%%%%% 
%///%%%%%%///,%%%%@@aa@@%//%%%@@@@S@@@%%///@@aa@@%%%%%,/%////%%%%% 
%%//%%%%%%%//,%%%%%///////%%%@S@@@@SS@@@%%/////%%%%%%%,%////%%%%%' 
%%//%%%%%%%//,%%%%/////%%@%@SS@@@@@@@S@@@@%%%%/////%%%,////%%%%%' 
`%/%%%%//%%//,%%%///%%%%@@@S@@@@@@@@@@@@@@@S%%%%////%%,///%%%%%' 
  %%%%//%%%%/,%%%%%%%%@@@@@@@@@@@@@@@@@@@@@SS@%%%%%%%%,//%%%%%' 
  `%%%//%%%%/,%%%%@%@@@@@@@@@@@@@@@@@@@@@@@@@S@@%%%%%,/////%%' 
   `%%%//%%%/,%%%@@@SS@@SSs@@@@@@@@@@@@@sSS@@@@@@%%%,//%%//%' 
    `%%%%%%/  %%S@@SS@@@@@Ss` .,,.    'sS@@@S@@@@%'  ///%/%' 
      `%%%/    %SS@@@@SSS@@S.         .S@@SSS@@@@'    //%%' 
               /`S@@@@@@SSSSSs,     ,sSSSSS@@@@@' 
             %%//`@@@@@@@@@@@@@Ss,sS@@@@@@@@@@@'/ 
           %%%%@@00`@@@@@@@@@@@@@'@@@@@@@@@@@'//%% 
       %%%%%%a%@@@@000aaaaaaaaa00a00aaaaaaa00%@%%%%% 
    %%%%%%a%%@@@@@@@@@@000000000000000000@@@%@@%%%@%%% 
 %%%%%%a%%@@@%@@@@@@@@@@@00000000000000@@@@@@@@@%@@%%@%% 
%%%aa%@@@@@@@@@@@@@@0000000000000000000000@@@@@@@@%@@@%%%% 
%%@@@@@@@@@@@@@@@00000000000000000000000000000@@@@@@@@@%%%%%"



#LOGIN -> SIGNUP
def welcome
  prompt = TTY::Prompt.new

  welcome_page = prompt.select("") do |welcome|
    welcome.choice 'Login'
    welcome.choice 'Signup'
  end

  if welcome_page == 'Login'
    prompt.collect do
      un = key(:username).ask('Please enter your username:', required: true)
      if !Adopter.find_by username: un
        puts "Username does not exist."
        signup   ###Test this
      end
      pw = key(:password).mask('Please enter your password:', required: true)
      while !Adopter.find_by password: pw
        puts "Incorrect password, please try again."
        pw = key(:password).mask('Please enter your password:', required: true)
      end
      search_menu
    end
  else
    signup
  end

end

##Account creation method
def signup
  prompt = TTY::Prompt.new

  account_prompt = prompt.select("Would you like to create an account?") do |acc|
    acc.choice 'Yes'
    acc.choice 'No'
  end

  if account_prompt == 'Yes'
    Adopter.create(prompt.collect do 
      key(:username).ask('Please enter your desired username:', required: true)
      while Adopter.all.include?(:username)    ##Add way for user to exit at any point
        puts "Username is already taken. Please try again."
        key(:username).ask('Please enter your desired username:', required: true)
      end
      key(:password).mask('Please enter your desired password:', required: true)
    end
    )
  else
    signup
  end
  welcome
end

def search_menu
  prompt = TTY::Prompt.new

  refiner = prompt.select("Hello UNKNOWN, you may choose to refine by location or immediately begin searching for a dog.") do |acc|
    acc.choice 'Refine By Location', 1
    acc.choice 'I will go to the ends of the earth to find a dog.', 2
  end

  if refiner == 1
    location_pref = refine_by_location
  else  
    #add number of dogs tracker while refining

  end
end

def refine_by_location
  prompt = TTY::Prompt.new

  borough_arr = prompt.multi_select("Please select the boroughs that you would like to search from.") do |boroughs|
    boroughs.choice :Queens
    boroughs.choice :Brooklyn
    boroughs.choice :Manhattan
    boroughs.choice :Bronx
    boroughs.choice :Staten_Island 
  end

  ans = (borough_arr.collect {|borough| Shelter.where location: borough}).flatten
end

welcome