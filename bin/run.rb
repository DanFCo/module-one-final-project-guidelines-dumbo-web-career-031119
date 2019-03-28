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



  welcome_page = prompt.select("", cycle: true, active_color: :blue) do |welcome|
    welcome.choice 'Login'
    welcome.choice 'Signup'
  end

  if welcome_page == 'Login'
   prompt.collect do
      un = key(:username).ask('Please enter your username:', required: true)
        pw = key(:password).mask('Please enter your password:', required: true)


@@current_user = Adopter.where("username = :username and password = :password",{username: un, password: pw})[0]



      if !Adopter.find_by username: un
        puts "Username does not exist."

        signup
      end
      while !Adopter.find_by password: pw, username: un
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

  account_prompt = prompt.select("Would you like to create an account?", cycle: true, active_color: :blue) do |acc|
    acc.choice 'Yes'
    acc.choice 'No'
  end

  if account_prompt == 'Yes'
    @@current_user = Adopter.create(prompt.collect do
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
  refiner = prompt.select("Hello #{@@current_user.username}, you may choose to refine by location or immediately begin searching for a dog.", cycle: true, active_color: :blue) do |acc|
    acc.choice 'Refine By Location', 1
    acc.choice 'I will go to the ends of the earth to find a dog.', 2
  end

  if refiner == 1
    location_pref = refine_by_location
    dog_pref = refine_by_dog_preference
    doggo_array = location_pref.collect{|location| location.dogs.where(dog_pref)}
  else
    location_pref = Shelter.all
    dog_pref = refine_by_dog_preference
    binding.pry
    doggo_array = location_pref.collect{|location| location.dogs.where(dog_pref)}
    binding.pry
  end
  select_dog(doggo_array.flatten)
end

def refine_by_location
  prompt = TTY::Prompt.new

  borough_arr = {location: prompt.multi_select("Please select the boroughs that you would like to search from.", cycle: true, active_color: :blue) do |boroughs|
    boroughs.choice :Queens
    boroughs.choice :Brooklyn
    boroughs.choice :Manhattan
    boroughs.choice :Bronx
    boroughs.choice :Staten_Island
  end
  }
  ans = Shelter.select("id").where(borough_arr)   ##could make Location table
end

def refine_by_dog_preference
  prompt = TTY::Prompt.new

  dog_pref_arr = {}
  dog_pref_arr[:size] = prompt.select("Please select the sizes that you would like to search from.", cycle: true, active_color: :blue) do |size|
    size.choice :Small
    size.choice :Medium
    size.choice :Large
    end


  dog_pref_arr[:personality] = prompt.select("Please select the personality that you prefer in your doggo.", cycle: true, active_color: :blue) do |personality|
    personality.choice :Active
    personality.choice :Calm
    end
binding.pry
  dog_pref_arr
end




def assign_user_to_dog(arg)
   doggy = Dog.find_by(id: arg.id)
   doggy.update(adopter_id: @@current_user.id)
end






def select_dog(dog_arr)
  prompt = TTY::Prompt.new

  if dog_arr.length == 0 
    puts "You're too picky! No dog for you! \n"
    puts "System restart"
    system 'clear'
    welcome
  else
    chosen_dog = prompt.select("Here are your choices of dogs you sick bastard.", cycle: true, active_color: :blue) do |doggo|
      dog_arr.each do |dog|
        if dog.adopter_id != nil
        doggo.choice  "#{dog.name} \nAge: #{dog.age} \nBreed: #{dog.breed}", -> {dog}, disabled: '(Unavailable: Dog already reserved)'
        else
        doggo.choice  "#{dog.name} \nAge: #{dog.age} \nBreed: #{dog.breed}", -> {dog}
        end
      end
    end
  end
  assign_user_to_dog(chosen_dog)
  congrats(chosen_dog)
end


def congrats(arg)

the_shelter = Shelter.find(arg.shelter_id)
  prompt = TTY::Prompt.new

  puts "\nCongrats! Your Dog Is Waiting For You at: \n #{the_shelter.name} \n Location: #{the_shelter.location} \n Kill Shelter: #{the_shelter.kill_shelter}"

  case prompt.yes?("Would you like to continue looking at dogs?")
  when true
    search_menu
  else
    Dog.update(shelter_id: nil).where(adopter_id == @@current_user.id)
    system"clear"
    system"^D"
  end

end











welcome
