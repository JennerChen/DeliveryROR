class PaypalBacksController < ApplicationController
	def create
		@order = Order.find_by_id(params[:invoice])
		if @order
			# PaymentNotification.create!(:params => params, :order_id => params[:invoice], :status => params[:payment_status], :transcation_id => params[:txn_id])
			flash[:success] = "order purchased"
			redirect_to "/orders/#{@order.id}"
		else
			render '/static_pages/home'
		end
	end
end
