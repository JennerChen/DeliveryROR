class DestinationsController < ApplicationController
  before_filter :signed_in_for_admin_user, only: [:new, :create, :destroy]
  
  def new
  	@destination=Destination.new
  end
  
  def index
    @destinations=Destination.all
  end
  def show
  	@destination = Destination.find(params[:id])
  end
  
  def create
  	 @destination = Destination.new(params[:destination])
    if @destination.save
      flash[:success] = "Destination created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy

  end
end