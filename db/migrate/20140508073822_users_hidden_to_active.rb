class UsersHiddenToActive < ActiveRecord::Migration
  def change
    remove_column :users, :active
    add_column :users, :active, :boolean, default: true
  end
end
