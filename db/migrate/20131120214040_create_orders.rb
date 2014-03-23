class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :destination_id
      t.integer :price
      t.string :state

      t.timestamps
    end
    add_index :orders, [:user_id, :created_at]
  end
end
