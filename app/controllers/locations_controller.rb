class LocationsController < ApplicationController

  def new
  	@location=Location.new
  end
  
  def index
    @locations=Location.all
  end

  def show
  	@location = Location.find(params[:id])
  	@result = request
  end
  
  def create
  	 @location = Location.new(params[:location])
    if @location.save
      flash[:success] = "location created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy

  end
end
