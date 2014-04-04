require 'grape'
require_relative './apihelpers'
require_relative './entities/itementity'
require_relative './entities/orderentity'
require_relative './entities/userentity'
module Ship
    module PrettyJSON
        def self.call(object, env)
         JSON.pretty_generate(JSON.parse(object.to_json))
        end
    end

    class Length < Grape::Validations::SingleOptionValidator
        def validate_param!(attr_name, params)
            unless params[attr_name].length <= @option[1] && params[attr_name].length >= @option[0]
            throw :error, status: 400, message: "#{attr_name}: must between #{@option[0]} and #{@option[1]} characters long"
            end
        end
    end
        
	class WSV1 < Grape::API
		version 'v1', using: :path 
        helpers Ship::AuthHelpers      
        helpers Ship::OrderHelpers
        helpers Ship::UserHelpers
        helpers Ship::ItemHelpers  
        helpers do
            def logger
            WSV1.logger
            end
        end
        include Grape::Kaminari
		format :json
        formatter :json, PrettyJSON

        before do    
         header['Access-Control-Allow-Origin'] = '*'
         header['Access-Control-Request-Method'] = '*'
        end

        get :hello do
            {hello: "hello from v1"}
        end
        resource :auth do
 
            desc "Creates and returns access_token if valid login"
            params do
                requires :login, :type => String, :desc => "Username"
                requires :password, :type => String, :desc => "Password"
            end
            post :login do
 
                if params[:login].include?("@")
                    user = User.find_by_email(params[:login].downcase)
                end
 
                if user && user.authenticate(params[:password])
                     logger.info "user #{user.id} login"
                    key = ApiKey.create(:user_id => user.id)
                     {:token => key.access_token}
                else
                    error!('Unauthorized.', 401)
                end
            end
 
            desc "Returns pong if logged in correctly"
            params do
                requires :token, :type => String, :desc => "Access token."
            end
            get :ping do
              authenticate!
               { :message => "pong" }
            end
           
        end        

    	resources :users do 
            desc "create a new user"
            params do
                requires :email, :type => String, :regexp => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :desc => "User email"
                requires :name, :type => String, :length => [6,15], :desc => "User name"
                requires :password, :type => String, :desc => "User password"
                requires :password_confirmation, :type => String, :desc => "User password confirmation"
                requires :telephone,  :type => String, :regexp => /^[0-9]{1,}$/, :desc => "User telephone number optional"
                optional :address, :type => String, :desc => "User address optional"   
            end
            post do
               @user= User.new 
               if !User.find_by_email(params[:email])
               @user.email = params[:email].downcase 
               @user.name= params[:name] 
               @user.password= params[:password] 
               @user.password_confirmation= params[:password_confirmation] 
               @user.role="customer"
               @user.telephone= params[:telephone] 
               @user.address = params[:address] if params[:address]
                    if  @user.save 
                        status 201
                        present @user, with: Entities::Userentity
                    else
                        error!({'Error' => 'Invalid parameters ', 'Detail' => "Your two passwords are different "}, 404)
                    end
               else
                 error!({'Error' => 'Invalid email ', 'Detail' => "Someone has taken the email: #{params[:email]}"}, 404)
               end
            end


            params do
                requires :token, :type => String, :desc => "Access token"
                optional :page, :type => Integer, :desc => "page number, default 1"
            end
            namespace do 
                desc "Only admin user can get all users"
                paginate 
			    get do
                    authenticate!
                    if params[:searchtype] && params[:searchtype] == 'email'
                        @user=find_user_by_eamil(params[:email]) if params[:email]
                          present @user, with: Entities::Userentity, :token => params[:token]
                    elsif current_user.role == "admin"
				          # @users=User.paginate(:page => params[:page], :per_page => params[:per_page] )
                        unless params[:page]
                            params[:page]=1
                        end
                          @count = User.all.count 
                          
                          if @count % 10 ==0 
                            @total_page = @count /10
                          else
                            @total_page = @count /10 + 1
                          end

                          @users=User.paginate(:page => params[:page], :per_page => 10 )
                          present :page, params[:page]
                          present :per_page, params[:per_page]
                          present :total_user, @count
                          present :total_page, @total_page
				          present :users, @users, with: Entities::Userentity, :token => params[:token]
                    else
                          error!( {'Error' => 'Invalid user right ', 
                            'Detail' => "You don't have right to access data"}, 404)
                        
                    end
                    
			    end

                params do
                    requires :id, :type => Integer, :desc => "User primary key"
                end 
                namespace ":id" do
			        desc "Only admin user or a user view personal information can get data"
			        get do
                        authenticate!
                        if user_isadmin! || current_user.id == params[:id]
				        @user=find_user(params[:id])
                        # UserRepresenter.new(@user)
				         present @user, with: Entities::Userentity, :token => params[:token]
                        else
                        error!( {'Error' => 'Invalid user right ', 
                            'Detail' => "You don't have right to get data"}, 404)
                        end
			        end

                    desc "Edit user profile"
                    put do
                        authenticate!

                        @user=find_user(params[:id])
                        if current_user.role == "admin" 
                            @user.name= params[:name] if params[:name]
                            @user.password= params[:password] if params[:password]
                            @user.password_confirmation= params[:password_confirmation] if params[:password_confirmation]
                            @user.telephone= params[:telephone] if params[:telephone]
                            @user.address = params[:address] if params[:address]
                            @user.role = params[:role] if params[:role]
                            
                        elsif current_user==@user
                            @user.name= params[:name] if params[:name]
                            @user.password= params[:password] if params[:password]
                            @user.password_confirmation= params[:password_confirmation] if params[:password_confirmation]
                            @user.telephone= params[:telephone] if params[:telephone]
                            @user.address = params[:address] if params[:address]
                        else   
                            error!( {'Error' => 'Invalid user right ', 
                            'Detail' => "You don't have right to edit profile"}, 404)
                        end

                        unless @user.save
                             error!( {'Error' => 'Invalid parameters', 
                            'Detail' => "please check your parameters"}, 404)
                        end
                        present @user, with: Entities::Userentity, :token => params[:token]
                    end
                    namespace 'orders' do
                        desc "add a new order for user"
                        params do
                            requires :destination_id, :type => Integer, :desc => "destination id"
                        end
                        post do 
                            authenticate!
                            @order=Order.new
                            @order.destination_id= params[:destination_id]
                            @order.user_id = current_user.id
                            @order.state='Nonactivated'
                            if @order.save
                                status 200
                                @order
                            else
                                error!( {'Error' => 'Invalid parameters', 
                                    'Detail' => "please check your parameters"}, 404)
                            end
                            present @order, with: Entities::Orderentity, :token => params[:token]
                        end

                        desc "get all orders of a user"
                        get do
                            authenticate!
                            @orders=[]
                            @orders=current_user.orders
                             # OrdersRepresenter.new @orders
                            present @orders, with: Entities::Orderentity, :token => params[:token]
                        end
                    end
                end

            end
		end

        resources :orders do 
            desc "get orders"
            params do
                requires :token, :type => String, :desc =>"access token"
                optional :searchtype, :type => String, :desc => "type of search value"
                optional :searchvalue, :type => String, :desc => "the value of searchtype"
            end
            get do
                authenticate!
                @orders=[]
                if params[:searchtype] && params[:searchvalue]
                    if params[:searchtype] == "receiverfirstname"
                        @orders=Order.all.select{ |order| order.receiverfirstname == params[:searchvalue]}
                    elsif params[:searchtype] == "receiversecondname"
                        @orders=Order.all.select{ |order| order.receiversecondname == params[:searchvalue]}
                    elsif params[:searchtype] == "state"
                        @orders=Order.all.select{ |order| order.state == params[:searchvalue]}
                    elsif params[:searchtype] == "iscomplete"
                        @orders=Order.all.select{ |order| order.iscomplete == params[:searchvalue]}
                    else
                        error!( {'Error' => ' service is not available', 
                            'Detail' => "sorry, the searchtype #{params[:searchtype]} is not available"}, 404)
                    end
                else
                    @orders=Order.all
                end
                present @orders, with: Entities::Orderentity
            end

            desc "create a new order"
            params do
                requires :token, :type => String, :desc =>"access token"
                requires :destination_id, :type => Integer, :desc => "destination id"
            end
            post do
                authenticate!
                @order=Order.new
                @order.destination_id= params[:destination_id]
                @order.user_id = current_user.id
                @order.state='Nonactivated'
                @order.price=0
                if @order.save
                    status 200
                    present @order, with: Entities::Orderentity
                else
                      error!( {'Error' => 'Invalid parameters', 
                            'Detail' => "please check your parameters"}, 404)
                end
            end

            params do
                requires :id, :type => Integer, :desc => "order id"
                requires :token, :type => String, :desc => "access token"
            end
            namespace ":id" do
                desc "edit order detail"
                params do
                    optional :price, :type => Integer, :desc => "order price"
                    optional :carrier_id, :type => Integer, :desc => "current carrier id"
                    optional :state, :type => String, :desc => "order statement "
                    optional :nowlocation, :type => String, :desc => "current order location"
                    optional :receiverfirstname, :type => String, :desc => "reciver first name"
                    optional :receiversecondname, :type => String, :desc => "reciver second name"
                    optional :receivertel, :type => String, :desc => "reciver telephone"
                    optional :receivemethod, :type => String, :desc => "reciver method"
                    optional :iscomplete, :type => Boolean, :desc => "order if complete"
                end
                put do
                    authenticate!
                    @order=find_order(params[:id])
                    if @order 
                        if !user_iscustomer!
                            @order.price=params[:price] if params[:price] && current_user.role=="admin"
                            @order.carrier_id=params[:carrier_id] if params[:carrier_id] && User.find_by_id(params[:carrier_id])
                            @order.state=params[:state] if params[:state]
                            @order.nowlocation= params[:nowlocation] if params[:nowlocation]
                            @order.receiverfirstname= params[:receiverfirstname] if params[:receiverfirstname]
                            @order.receiversecondname= params[:receiversecondname] if params[:receiversecondname]
                            @order.receivertel= params[:receivertel] if params[:receivertel]
                            @order.receivemethod= params[:receivemethod] if params[:receivemethod]
                            @order.iscomplete= params[:iscomplete] if params[:iscomplete]
                            if @order.save
                               status 200
                              present @order, with: Entities::Orderentity
                            else 
                                error!( {'Error' => 'error', 
                            'Detail' => "please check"}, 404)
                            
                            end
                        else
                            error!( {'Error' => 'Invalid user', 
                            'Detail' => "current_user role cannot edit order"}, 404)
                        end
                    else
                        error!( {'Error' => 'Invalid order id', 
                            'Detail' => "no order with order id #{params[:id]}"}, 404)
                    end
                end

                desc "get order with id"
                get do
                    @order=find_order(params[:id])
                    if @order 
                        present @order, with: Entities::Orderentity
                    else
                        error!( {'Error' => 'Invalid order id', 
                            'Detail' => "no order with order id #{params[:id]}"}, 404)
                    end
                end

                namespace "items" do
                    desc "get items for an order"
                    get do
                        authenticate!
                        @items=[]
                        @order=find_order[:params[:id]]
                        if @order
                            @items=@order.items
                            present @items, with:: Entities::Itementity
                        else
                            error!( {'Error' => 'Invalid order id', 
                            'Detail' => "no order with id of #{params[:id]}"}, 404)
                        end
                    end
                end

            end
        end

        resources :items do
            desc "get items"
            params do
                requires :token, :type => String, :desc => "access token"
                requires :searchtype, :type => String, :desc => "search type"
                requires :searchvalue, :type => String, :desc => "search value"
            end
            get do
                authenticate!
                @items=[]
                if params[:searchtype]=="orderid" &&  params[:searchvalue].to_i
                    @order=find_order(params[:searchvalue].to_i)
                    @items=@order.items
                elsif params[:searchtype]=="categoryname" 
                    @category=find_category_by_name(params[:searchvalue])
                    if @category
                        @items=@category.items
                        present @items, with: Entities::Itementity
                    else
                        error!( {'Error' => 'Invalid order id', 
                            'Detail' => "no name of category with category id #{params[:searchvalue]}"}, 404)
                    end
                elsif params[:searchtype]=="userid" && params[:searchvalue].to_i
                    @user=find_user(params[:id])
                    @items=@user.items
                    present @items, with: Entities::Itementity
                else
                     error!( {'Error' => ' service is not available', 
                            'Detail' => "sorry, the searchtype #{params[:searchtype]} is not available"}, 404)        
                end
            end

            desc "create a new item for a order"
            params do
                requires :token, :type => String, :desc => "access token"
                requires :orderid, :type => Integer, :desc => "order id"
                requires :categoryname, :type => String, :desc => "category name"
                requires :weight, :type => Integer, :desc => "item weight kg"
            end
            post do
                authenticate!
                @item=Item.new
                @item.user_id = current_user.id
                @item.order_id = params[:orderid] if find_order(params[:orderid])
                @category= find_category_by_name(params[:categoryname])
                if @category
                   @item.category_id = @category.id
                else
                    @item.category_id = 1
                end
                @item.weight = params[:weight]
                if @item.save
                    status 200
                    present @item, with: Entities::Itementity
                else
                    error!( {'Error' => 'fail to create item', 
                            'Detail' => "Invalid params for item, please check"}, 404) 
                end
            end
        end
        add_swagger_documentation :base_path => '/ws', :api_version => "v1"

	end
end