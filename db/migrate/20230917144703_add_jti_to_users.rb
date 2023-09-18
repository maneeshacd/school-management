class AddJtiToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :jti, :string
    change_column_null :users, :jti, false
    add_index :users, :jti, unique: true
  end
end
