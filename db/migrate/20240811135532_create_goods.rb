class CreateGoods < ActiveRecord::Migration[7.1]
  def change
    create_table :goods do |t|
      t.string :brand
      t.integer :price
      t.string :colour
      t.integer :code
      t.integer :quantity
      t.integer :size

      t.timestamps
    end
  end
end
