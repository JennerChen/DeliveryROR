class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :user_id
      t.integer :order_id
      t.integer :category_id
      t.integer :quantity
      t.integer :weight
      t.integer :price
      t.string :describe

      t.timestamps
    end
    add_index :items, [:user_id, :order_id, :category_id]
  end
end
