Adopter.destroy_all
Dog.destroy_all
Shelter.destroy_all

m_vick = Adopter.create(name: "Michael Vick", age: 38)

barkr = Shelter.create(name: "Barkr", location: "White Plains", kill_shelter: true)
dogs_r_us = Shelter.create(name: "Dogs R Us", location: "Brooklyn", kill_shelter: false )
dogs_dogs_dogs = Shelter.create(name:"Dogs Dogs Dogs", location:"Queens", kill_shelter: false)
roofus = Shelter.create(name:"Roofus and Friends", location:"Queens", kill_shelter: true)

scoobs = Dog.create(name: "Scooby Doo", age: 7, size: "Large", breed: "Great Dane", shelter_id: barkr.id)
clifford = Dog.create(name: "Clifford", age: 5, size: "Large", breed: "Big Red Dog", shelter_id: dogs_r_us.id)
air_bud = Dog.create(name: "Air Bud", age: 3, size: "Large", breed: "Golden Retriever", shelter_id: dogs_r_us.id)
ginger = Dog.create(name: "Ginger", age: 4, size: "Large", breed: "German Shepherd", shelter_id: dogs_dogs_dogs.id)
gizmo = Dog.create(name: "Gizmo", age: 5, size: "Small", breed: "Morkie", shelter_id: dogs_dogs_dogs.id)
lucky = Dog.create(name: "Lucky", age: 5, size: "Small", breed: "Morkie", shelter_id: roofus.id)
peanut = Dog.create(name: "Peanut", age: 4, size: "Large", breed: "German Shepherd", shelter_id: roofus.id)

