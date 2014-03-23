class AddSomeColumnsToUsersForFinalProject < ActiveRecord::Migration
  def change
  	add_column :users, :telephone, :string 
  	add_column :users, :address, :string 
  	add_column :users, :bankinfo, :string
  end
end
