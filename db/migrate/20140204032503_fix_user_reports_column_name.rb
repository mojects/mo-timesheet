class FixUserReportsColumnName < ActiveRecord::Migration
  def change
    rename_column :user_reports, :reports_pack_id, :report_id
  end
end
