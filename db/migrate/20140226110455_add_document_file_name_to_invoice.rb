class AddDocumentFileNameToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :document_file_name, :string, limit: 1000
  end
end
