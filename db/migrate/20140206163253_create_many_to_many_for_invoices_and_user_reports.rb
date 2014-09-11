class CreateManyToManyForInvoicesAndUserReports < ActiveRecord::Migration
  def change
    create_table :invoices_packs_user_reports do |t|
      t.belongs_to :invoices_pack
      t.belongs_to :user_report
      t.timestamp
    end
  end
end
