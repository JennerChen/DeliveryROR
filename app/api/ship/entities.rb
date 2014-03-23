# module Ship
# module Entities

#     class Orderentity < Grape::Entity
#         expose :id, :as => :order_id
#         expose :destination_id, :as => :destination
#         expose :state
#         expose :receiverfirstname
#         expose :receiversecondname
#         expose :receiveraddress
#         expose :iscomplete
#         expose :nowlocation
#     end
    
#     class Itementity <Grape::Entity 
#         expose :id, :as => :item_id
#         expose :user_id, :as => :owner_id
#         expose :category_id
#     end

#     class Userentity < Grape::Entity
#       expose :name, :as => :name
#       expose :email, :as => :email
#       expose :role, :as => :role
#       expose :address, :address, unless: {:address => nil }
#       expose :url do |user,opts| 
#             "http://#{opts[:env]['HTTP_HOST']}" + 
#              "/ws/v1/users/#{user.id}?token=4aa30f535b1d1cb3c337f5d998adbd0f"
#         end
#       expose :orders, :using => Orderentity, :as => :orderlist
#     end
    
# end

# end