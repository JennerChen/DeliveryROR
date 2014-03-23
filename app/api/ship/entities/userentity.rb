module Entities
	class Userentity < Grape::Entity
      expose :name, :as => :name
      expose :email, :as => :email
      expose :role, :as => :role
      expose :address, :address, unless: {:address => nil }
      expose :user_url do |user,opts| 
           url= "http://#{opts[:env]['HTTP_HOST']}/ws/v1/users/#{user.id}" 
           url=url +  "?token=#{opts[:token]}" if opts[:token]    
           url 
      end

      expose :orders, :using => Orderentity, :as => :orderlist
    end
end