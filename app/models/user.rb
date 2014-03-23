class User < ActiveRecord::Base
  attr_accessible :email, :name, :role, :password, :password_confirmation, :telephone, :address, :bankinfo
  has_secure_password  
  has_many :orders, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :delivery_items, :class_name => "Order" ,
            :through => :items, :source => :order
  before_save do |user| 
        user.email = email.downcase 
        user.remember_token = SecureRandom.urlsafe_base64
        end
  
  validates :name, length: { in: 4..30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
   			uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :role, inclusion: { in: 
                     ['admin', 'carrier','customer']}
  # validates :telephone, length: { in: 6..15 }
  
end
