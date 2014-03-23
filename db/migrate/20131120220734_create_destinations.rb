class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :start
      t.string :dst
      t.integer :price

      t.timestamps
    end
    add_index :destinations, [:start, :dst]
  end
end
