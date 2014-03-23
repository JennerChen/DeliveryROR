require 'representable/json/collection'
require 'roar/decorator'

    class OrdersRepresenter < Roar::Decorator
      include Representable::JSON::Collection

      items  class: Order,  
            :decorator => OrderRepresenter
    end