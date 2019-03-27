system "clear"
require_relative '../config/environment'

def welcome
  header = Artii::Base.new :font => 'fuzzy'
  prompt = TTY::Prompt.new

  puts header.asciify('Doogle!')

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



  welcome_page = prompt.select("") do |welcome|
    welcome.choice 'Login'
    welcome.choice 'Signup'
  end

  if welcome_page == 'Login'
    prompt.collect do
      un = key(:username).ask('Please enter your username:', required: true)
      if !Adopter.find_by username: un
        puts "Username does not exist."
        signup 
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
    binding.pry
    dog_pref = refine_by_dog_preference
    doggo_array = location_pref.collect{|location| location.dogs.where(dog_pref)}
  else  
    dog_pref = refine_by_dog_preference
    doggo_array = Dog.where(dog_pref)
  end
  doggo_array
end

def refine_by_location
  prompt = TTY::Prompt.new

  borough_arr = {location: prompt.multi_select("Please select the boroughs that you would like to search from.") do |boroughs|
    boroughs.choice :Queens
    boroughs.choice :Brooklyn
    boroughs.choice :Manhattan
    boroughs.choice :Bronx
    boroughs.choice :Staten_Island 
  end
  }
  binding.pry
  ans = Shelter.select("id").where(borough_arr)   ##could make Location table
end

def refine_by_dog_preference
  prompt = TTY::Prompt.new

  dog_pref_arr = {}
  dog_pref_arr[:size] = prompt.select("Please select the sizes that you would like to search from.") do |size|
    size.choice :Small
    size.choice :Medium
    size.choice :Large
    end
  

  dog_pref_arr[:personality] = prompt.select("Please select the personality that you prefer in your doggo.") do |personality|
    personality.choice :Active
    personality.choice :Calm
    end
  
  dog_pref_arr
end

welcome