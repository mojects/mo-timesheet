class RenameInvoicePackIdToInvoicesPackIdInInvoices < ActiveRecord::Migration
  def change
    rename_column :invoices, :invoice_pack_id, :invoices_pack_id
  end
end
