class Dog < ActiveRecord::Base
    belongs_to :adopter
    belongs_to :shelter

    serialize :wishlist_ids, Array
end