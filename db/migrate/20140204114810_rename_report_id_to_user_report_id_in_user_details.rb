class RenameReportIdToUserReportIdInUserDetails < ActiveRecord::Migration
  def change
    rename_column :user_details, :report_id, :user_report_id
  end
end
