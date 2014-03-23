require 'grape'
module Ship
   module OrderHelpers
    def find_order(id)
        @order = Order.find_by_id(id)
        unless @order 
           error!( {'Error' => 'Invalid resource id', 
                         'Detail' => "No order with id of: #{id}"}, 404)
        end
        @order
    end

  end

  module AuthHelpers
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end
 
    def current_user
      # find token. Check if valid.
      user_token = params[:token]
      token = ApiKey.where(:access_token => user_token).first
      if token && !token.expired?
        @current_user = User.find(token.user_id)
      else
        false
      end
    end

    def user_isadmin!
      if current_user.role == "admin"
        true
      else
        false
      end
    end

    def user_iscarrier!
      if current_user.role == "carrier"    
        true
      else
        false
      end
    end

    def user_iscustomer!
      if current_user.role == 'customer'
        true
      else
        false
      end  
    end

  end

  module UserHelpers
    def find_user(id)
      @user=User.find_by_id(id)
      unless @user
        error!( {'Error' => 'Invalid resource id', 
                         'Detail' => "No user with id of: #{id}"}, 404)
        
      end
      @user
    end

    def find_user_by_eamil(email)
      @user=User.find_by_email(email.downcase)
      unless @user
        error!( {'Error' => 'Invalid resource email', 
                         'Detail' => "No user with email of: #{email}"}, 404)
      end
      @user
    end
  end

  module ItemHelpers
    def find_item(id)
      @item=Item.find_by_id(id)
      unless @item
        error!( {'Error' => 'Invalid resource id', 
                         'Detail' => "No item with id of: #{id}"}, 404)
      end
      @item
    end
  end

  module CategoryHelpers
    def find_category_by_name(name)
      @category=Category.find_by_name(name.downcase)
      unless @category
        error!( {'Error' => 'Invalid resource name', 
                         'Detail' => "No category with name of: #{name}"}, 404)
      end
      @category
    end
  end

end