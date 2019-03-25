Adopter.delete_all
Dog.delete_all
Shelter.delete_all

m_vick = Adopter.create(name: "Michael Vick", age: 38)

scoobs = Dog.create(name: "Scooby Doo", age: 7, size: "Large", breed: "Great Dane")
clifford = Dog.create(name: "Clifford", age: 5, size: "Large", breed: "Big Red Dog")
air_bud = Dog.create(name: "Air Bud", age: 3, size: "Large", breed: "Golden Retriever")
ginger = Dog.create(name: "Ginger", age: 4, size: "Large", breed: "German Shepherd")
gizmo = Dog.create(name: "Gizmo", age: 5, size: "Small", breed: "Morkie")

barkr = Shelter.create(name: "Barkr", location: "White Plains", kill_shelter: true)
dogs_r_us = Shelter.create(name: "Dogs R Us", location: "Brooklyn", kill_shelter: false )
dogs_dogs_dogs = Shelter.create(name:"Dogs Dogs Dogs", location:"Queens", kill_shelter: false)
roofus = Shelter.create(name:"Roofus and Friends", location:"Queens", kill_shelter: true)
