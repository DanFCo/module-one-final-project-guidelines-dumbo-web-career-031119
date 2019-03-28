class AddWishlistIdsToDogs < ActiveRecord::Migration[4.2]
    def change
        add_column :dogs, :wishlist_ids, :string
    end
  end
  