 require 'roar/decorator'
     class OrderRepresenter  < Roar::Decorator
        include Roar::Representer::JSON
        include Roar::Representer::Feature::Hypermedia  # NEW

        link :self do    # NEW
           "http://localhost:3000/ws/v1/orders/#{represented.id}"
        end
        property :id
        property :user_id
        property :state
        property :destination_id
        property :price

        link :items do     # NEW
           "http://localhost:3000/ws/v1/orders/#{represented.id}/items"
        end
    end
