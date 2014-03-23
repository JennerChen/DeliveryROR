class Destination < ActiveRecord::Base
  attr_accessible :dst, :price, :start
  has_many :orders
  validates :dst, length: { in: 2..30 }, presence: true
  validates :start, length: { in: 2..30 }, presence: true  
  validates :price, :numericality => {:only_integer => true}
end
