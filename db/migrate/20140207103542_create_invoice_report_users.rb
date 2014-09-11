class CreateInvoiceReportUsers < ActiveRecord::Migration
  def change
    create_table :invoice_report_users do |t|
      t.belongs_to :invoice
      t.belongs_to :report_user

      t.timestamps
    end
  end
end
