# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Create some users
# User.create(name:'Jenner', email:'zhangqing332@live.com', password: "123456", password_confirmation: "123456")
# Destination.create(start:'Waterford', dst:'Dublin', price:5)
# Destination.create(start:'Waterford', dst:'Cork', price:3)
# user = User.find(1)
# user.orders.create(price: 5, state: 'Dispatched', destination_id: 1)
# user.orders.create(price: 6, state: 'Dispatching', destination_id: 2)
# user.orders.create(price: 10, state: 'Dispatched', destination_id: 1)

User.create(name:'Jenner', email:'zhangqing332@live.com', password: "123456", password_confirmation: "123456", role: "admin")

