class RenameRoleToUsers < ActiveRecord::Migration
  def up
  end

  def down
  end
  def change
  	 rename_column :users, :type, :role
  end
end
