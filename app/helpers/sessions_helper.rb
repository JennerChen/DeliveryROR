module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user  
    self.role_user=user
  end


  def signed_in?
    !current_user.nil?
  end

  def signed_in_admin?
    if signed_in?
      current_user.role == 'admin'
    end
  end

  def signed_in_admin_or_carrier?
    if signed_in?
      current_user.role == 'admin' || current_user.role == 'carrier'
    end
    
  end

  def current_user=(user)
    @current_user = user
  end
  

  def role_user=(user)
  	@role_user=user.role
  	
  end
# 获取用户的cookie信息，来得到当前用户
  def current_user
    if @current_user.nil?
       @current_user = 
           User.find_by_remember_token(cookies[:remember_token]) 
    end
    @current_user
  end

  def sign_out
  	self.current_user = nil
    cookies.delete(:remember_token)

  end
  def signed_in_user

    unless signed_in?
      store_location
      flash[:notice] = "Please sign in"
      redirect_to signin_url
    end
  end


  def signup_user
    #only admin or not signin user can signup new user
    if (signed_in? && (current_user.role=='carrier' || current_user.role =='customer'))
      flash[:notice]= "you have already signined as #{current_user.name}"
      redirect_to root_url
    end
  end
  
  def signed_in_for_admin_user

    unless signed_in?
      store_location
      flash[:notice] = "Please sign in"
      redirect_to signin_url
    else
      case current_user.role
      when 'admin'
        flash[:success] = "Welcome, #{current_user.name}"
      when 'carrier'
        flash[:notice] = "Sorry, this page only open for admin, if you want create, please contact admin"
        redirect_to root_url
      when 'customer'
        flash[:notice] ="Sorry, this page doesn't exist"
        redirect_to root_url
      
      end
    end
  end 
#9.2.3
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end


end
