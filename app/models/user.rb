class User < ActiveRecord::Base
  attr_accessible :email, :name, :type, :password, :password_confirmation
  has_secure_password  
  before_save { |user| user.email = email.downcase }
  validates :name, length: { in: 4..30 }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
   			uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
