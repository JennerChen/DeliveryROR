class Item < ActiveRecord::Base
  attr_accessible :category_id, :describe, :order_id, :price, :quantity, :user_id, :weight
  validates :price, :numericality => {:only_integer => true}
   belongs_to :user      
   belongs_to :order
   belongs_to :category
end
