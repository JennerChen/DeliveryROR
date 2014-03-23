class StaticPagesController < ApplicationController
  def home
  	
  end
   #通过order id查找订单，并且跳转至该订单
  def create
  	if params[:orderid] && !params[:orderid].blank? && params[:orderid].to_i !=0
  		@orderid=params[:orderid].to_i
  	  redirect_to "/orders/#{@orderid}"
    else
      flash[:error]="input #{params[:orderid]} is not a validate value, here are all order's lists"
      redirect_to "/orders"

    end
  end

  def manage
    unless current_user && current_user.role == 'admin'
      flash[:error]= "this page does not exist"
      redirect_to root_url
    end
  end
end
