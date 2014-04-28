class PaypalBacksController < ApplicationController
	def create
		@order = Order.find_by_id(params[:invoice])
		if @order
			flash[:success] = "order purchased"
			redirect_to "/orders/#{@order.id}"
		else
			render '/static_pages/home'
		end
	end
end
