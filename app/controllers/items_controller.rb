class ItemsController < ApplicationController
  
  before_filter :signed_in_user, only: [:new, :create]
  before_filter :signed_in_for_admin_user, only: [:destroy]

  def new
  	@item=Item.new
  end

  def index
    @items=Item.all
  end

  def show
  	@item = Item.find(params[:id])
  end
  
  def create

      @order=Order.find(params[:order][:id])
    if @order

  	  @item = @order.items.build(params[:item])
      @item.price= Category.find(@item.category_id).price * @item.weight * @item.quantity
      @item.user_id = current_user.id
      @order.price = @item.price.to_i + @order.price.to_i
      
    else 
      flash[:error]= "Sorry, you must have an order before you create new item"
      render '/orders/new'
    end

    if @item.save && @order.save
      flash[:success] = "Item has created! please confirm order"
      render "/orders/edit"
    else
      render 'static_pages/home'
    end
  end

  def destroy

  end
end