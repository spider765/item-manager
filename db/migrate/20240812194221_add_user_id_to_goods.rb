class AddUserIdToGoods < ActiveRecord::Migration[7.1]
  def change
    add_column :goods, :user_id, :integer
    add_index :goods, :user_id
  end
end
