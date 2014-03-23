 require 'roar/decorator'
     class UserRepresenter  < Roar::Decorator
        include Roar::Representer::JSON
        include Roar::Representer::Feature::Hypermedia  

        link :self do   
           "http://localhost:3000/ws/v1/users/#{represented.id}"
        end
        property :name  
        property :role 
        property :email
        property :address

        link :orders do   
           "http://localhost:3000/ws/v2/users/#{represented.id}/orders"
        end
    end
