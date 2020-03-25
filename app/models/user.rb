class User < ApplicationRecord
    has_many :subscriptions
    has_many :saved_shows
    has_secure_password
    validates :email, uniqueness: { case_sensitive: false }
    validates :name, :email, :password, presence: true 
end
