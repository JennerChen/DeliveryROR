class PaymentNotification < ActiveRecord::Base
  attr_accessible :id, :order_id, :params, :status, :transcation_id
  belongs_to :order
  serialize :params
  after_create :mark_cart_as_purchased

  private

  def mark_order_as_purchased
    if status == "Completed"
       order.update_attribute(:paymentid, id)
    end
  end
end
