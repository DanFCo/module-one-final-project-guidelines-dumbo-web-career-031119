class Adopter < ActiveRecord::Base
    has_many :dogs
    has_many :shelters, through: :dogs
end
