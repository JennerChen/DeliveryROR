class AddSomeColumnsToOrdersForFinalProject < ActiveRecord::Migration
  def change
  	add_column :orders, :carrier_id, :integer
  	add_column :orders, :nowlocation, :string
  	add_column :orders, :allshippingdetail, :string
  	add_column :orders, :receiverfirstname, :string
  	add_column :orders, :receiversecondname, :string
  	add_column :orders, :receiveraddress, :string
  	add_column :orders, :receivertel, :string
  	add_column :orders, :receivemethod, :string
  	add_column :orders, :iscomplete, :boolean
  end
end
