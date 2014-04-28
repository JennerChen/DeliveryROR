class Order < ActiveRecord::Base
  attr_accessible :destination_id, :price, :state, :nowlocation, :receiverfirstname, :receiversecondname, :receiveraddress, :receivertel, :receivemethod, :iscomplete, :fromlocation, :tolocation, :paymentid
  
  belongs_to :user    
  # belongs_to :destination
  has_many :items, dependent: :destroy

  validates :user_id, presence: true
  validates :state, presence: true, length: { maximum: 20 }
  validates :price, :numericality => {:only_integer => true}
  validates :state, inclusion: { in: 
                     ['Dispatching', 'Dispatched','Complete','In_Stock','Nonactivated']}
  default_scope order: 'orders.created_at DESC'

  
end
