class AddPersonalityToDogs < ActiveRecord::Migration[4.2]
    def change
        add_column :dogs, :personality, :string
    end
  end
  