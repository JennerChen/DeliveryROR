module Entities
	class Itementity <Grape::Entity 
        expose :id, :as => :item_id
        expose :user_id, :as => :owner_id
        expose :category_id
    end
end