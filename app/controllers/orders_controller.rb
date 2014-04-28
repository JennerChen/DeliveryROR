class OrdersController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create]
  before_filter :signed_in_for_admin_user, only: [:destroy]

  def new
  	@order=Order.new
  end

  def index
    @orders = Order.all
   
  end


  def show

  	@order=Order.find_by_id(params[:id])
    
    unless @order
      flash[:erroo]='error, the order does not exist'
      redirect_to root_url
    end
    
    if @order
    @items=@order.items
    end

    
  end

  def create
  	 @order = current_user.orders.build(params[:order])
     @fromlocation = Location.new(:address => params[:order][:fromlocation])
     @tolocation = Location.new( :address => params[:order][:tolocation])
     if @fromlocation.save && @tolocation.save 
     @order.fromlocation = @fromlocation.id
     @order.tolocation = @tolocation.id
     
     distance = @fromlocation.distance_from([@tolocation.latitude, @tolocation.longitude]).to_i
     @order.price = distance /100
      #All of new orders state is In_Stock
     @order.state='In_Stock'
     # @order.price= Destination.find(@order.destination_id).price
    if @order.save
      flash[:success] = "Order has created!, please input information of goods"
      @item=Item.new
      render '/items/new'
    else
      render 'static_pages/home'
    end
    end
  end

  def edit
      @order = Order.find(params[:id])
      unless @order.user_id == current_user.id || current_user.role == 'admin' || current_user.role ='carrier'
        flash[:error]='Sorry, only signed in person can edit his profile'
        redirect_to '/signin'
      end
  end

  def update
      @order = Order.find(params[:id])
      if @order.update_attributes(params[:order])
        flash[:success] = "Order successfully generated"
        redirect_to paypal_url(orders_url+"/#{@order.id}", payment_notifications_url)
        # redirect_to @order  
      else
        render 'edit'    

    end
  end

  def destroy
    
  end


  def paypal_url(return_url, notify_url)
  values = {
    :business => 'Jenner332-facilitator@gmail.com',
    :cmd => '_xclick',
    :upload => 1,
    :return => return_url,
    :invoice => @order.id,
    :notify_url => notify_url
  }
 
    values.merge!({
      "amount" => @order.price,
      "item_name" => 'Online Order',
      "item_number" => @order.id
    })
  "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
end
end