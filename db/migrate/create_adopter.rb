class CreateAdopters < ActiveRecord::Migration

def change
  create_table :adopters do |t|
    t.string :name
    t.string :age
    t.timestamps
  end
end

end
