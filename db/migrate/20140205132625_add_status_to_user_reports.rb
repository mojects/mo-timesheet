class AddStatusToUserReports < ActiveRecord::Migration
  def change
    add_column :user_reports, :status, :string, default: 'pending'
    add_index :user_reports, :status
  end
end
