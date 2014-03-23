class Category < ActiveRecord::Base
  attr_accessible :name, :price
  has_many :items
  validates :name, presence: true
  validates :price, :numericality => {:only_integer => true}
end
