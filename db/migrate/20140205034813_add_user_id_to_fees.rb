class AddUserIdToFees < ActiveRecord::Migration
  def change
    add_column :fees, :user_id, :integer
  end
end
