class InvoiceUserReport < ActiveRecord::Base
  self.table_name = 'invoice_report_users'
  belongs_to :invoice
  belongs_to :user_report, foreign_key: 'report_user_id'
end
