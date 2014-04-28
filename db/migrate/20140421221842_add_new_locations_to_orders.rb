class AddNewLocationsToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :fromlocation, :integer
  	add_column :orders, :tolocation, :integer
  	add_column :orders, :paymentid, :integer
  end
end
