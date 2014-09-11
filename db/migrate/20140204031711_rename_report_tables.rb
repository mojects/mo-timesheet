class RenameReportTables < ActiveRecord::Migration
  def change
    rename_table :reports, :user_reports
    rename_table :reports_packs, :reports
  end
end
