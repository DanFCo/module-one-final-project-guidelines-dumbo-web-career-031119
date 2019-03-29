class AddPastShelterIdToDogs < ActiveRecord::Migration[4.2]
    def change
        add_column :dogs, :past_shelter_id, :integer
    end
  end
  