class InvoicesPacksUserReport < ActiveRecord::Base
  belongs_to :user_report
  belongs_to :invoices_pack
end
