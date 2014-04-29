module Entities
	class Orderentity < Grape::Entity
        expose :id, :as => :order_id
        # expose :destination_id, :as => :destination
        expose :fromlocation
        expose :tolocation
        expose :price
        expose :state
        expose :receiverfirstname
        # , :receiverfirstname, unless: {:receiverfirstname => nil }
        expose :receiversecondname
        # , :receiversecondname, unless: {:receiversecondname => nil }
        expose :receiveraddress
        # , :receiveraddress, unless: {:receiveraddress => nil }
        expose :iscomplete
        # , :iscomplete, unless: {:iscomplete => nil }
        expose :nowlocation
        # , :nowlocation, unless: {:nowlocation => nil }
        expose :items, :using => Itementity, :as => :itemlist
        expose :paymentid
        # , :transcation_id, unless: {:paymentid => nil}
        expose :order_url do |order,opts| 
          url=  "http://#{opts[:env]['HTTP_HOST']}" + 
             "/ws/v1/orders/#{order.id}"
             url = url +"?token=#{opts[:token]}" if opts[:token]
             url
        end
    end
end