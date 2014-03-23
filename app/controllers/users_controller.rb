class UsersController < ApplicationController
  before_filter :signup_user, only: [:new, :create]
  # before_filter :signup_user, only: [:show]
  before_filter :signed_in_for_admin_user, only: [:index]
  def new
  	@user=User.new
  end

  def show
    @user = User.find(params[:id])
   
    @orders = @user.orders

    @items = @user.items
  end

  def index
    @users= User.all
  end
  
  def create
    
    @user = User.new(params[:user])
    #signup admin role
    if @user.role == 'admin' 
      #check again signin user is admin right
      if current_user.role == 'admin'
        if @user.save
         redirect_to @user
         flash[:success] = "Welcome to my project!"
        else
         flash[:error] = "Sorry, please check error"
         render 'new'
        end
      else
        flash[:error] ="Please signin"
        render 'new'
      end
    else 
      if @user.save
         redirect_to @user
         flash[:success] = "Welcome to my project!"
        else
         flash[:error] = "Sorry, please check error"
         render 'new'
      end
    end
  end

  def edit
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:error]='Sorry, only signed in person can edit his profile'
        redirect_to '/signin'
      end
  end

  def update
           @user = User.find(params[:id])
           if @user.update_attributes(params[:user])
                flash[:success] = "Profile updated"
                sign_in @user
                redirect_to @user  
           else
                render 'edit'    

    end
  end

end 
       
  
  

