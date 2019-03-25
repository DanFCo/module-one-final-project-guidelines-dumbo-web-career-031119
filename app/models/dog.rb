class Dog < ActiveRecord::Base
    belongs_to :adopters
    belongs_to :shelters
end