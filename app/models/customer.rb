class Customer < ApplicationRecord
    validates :email, uniqueness: true
end
