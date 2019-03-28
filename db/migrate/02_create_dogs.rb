class CreateDogs < ActiveRecord::Migration[4.2]
  def change
    create_table :dogs do |t|
      t.string :name
      t.integer :adopter_id
      t.integer :shelter_id
      t.integer :age
      t.string :size
      t.string :sex
      t.string :breed
      t.timestamps
    end
  end
end
