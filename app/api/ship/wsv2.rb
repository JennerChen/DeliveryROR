require 'grape'
require_relative './apihelpers'
module Ship
  class WSV2 < Grape::API
        version 'v2', using: :path
        helpers Ship::AuthHelpers
        format :json

        before do    
         header['Access-Control-Allow-Origin'] = '*'
         header['Access-Control-Request-Method'] = '*'
        end
        
        get :hello do
            { hello: "hello from v2, please use v1, ALL V2 function are not avaible now"}
        end

        add_swagger_documentation :base_path => '/ws', :api_version => "v2"
    end

end