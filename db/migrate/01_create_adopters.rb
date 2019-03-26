class CreateAdopters < ActiveRecord::Migration[4.2]
  def change
    create_table :adopters do |t|
      t.string :name
      t.integer :age
      t.string :username
      t.string :password
      t.string :preferences
      t.timestamps
    end
  end
end
