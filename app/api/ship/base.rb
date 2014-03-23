require_relative 'wsv1'
require_relative 'wsv2'
require 'grape'
require 'grape-swagger'

module Ship
  class Base < Grape::API
    mount Ship::WSV1
    mount Ship::WSV2
    route :any, '*path' do
        error!("Move along now, nothing to see here", 404)
    end
    add_swagger_documentation  :base_path => '/ws'
  end
end