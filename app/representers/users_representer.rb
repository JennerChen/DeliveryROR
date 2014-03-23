require 'representable/json/collection'
require 'roar/decorator'

    class UsersRepresenter < Roar::Decorator
      include Representable::JSON::Collection

      items  class: User,  
            :decorator => UserRepresenter
    end