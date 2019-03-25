class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :adopter
      t.string :shelter
      t.integer :age
      t.string :size
      t.string :breed
      t.timestamps
    end
  end
end
