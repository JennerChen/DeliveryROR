class CategoriesController < ApplicationController
	
  before_filter :signed_in_for_admin_user, only: [:new, :create, :destroy]
  
  
  def index
    @categories = Category.all
  end  

  def new
  	@category=Category.new
  end

  def show
  	@category = Category.find(params[:id])
  end
  
  def create
  	 @category = Category.new(params[:category])
    if @category.save
      flash[:success] = "Category created!"
      redirect_to root_url
    else

      render '/categories/new'
    end
  end

  def destroy
  end
end
