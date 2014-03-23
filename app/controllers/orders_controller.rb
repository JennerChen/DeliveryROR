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
      #All of new orders state is In_Stock
     @order.state='In_Stock'
     @order.price= Destination.find(@order.destination_id).price
    if @order.save
      flash[:success] = "Order has created!, please input information of goods"
      @item=Item.new
      render '/items/new'
    else
      render 'static_pages/home'
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
                
        redirect_to @order  
      else
        render 'edit'    

    end
  end

  def destroy
    
  end
end