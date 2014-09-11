class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.belongs_to :invoice_pack
      t.belongs_to :user
      t.belongs_to :report
      t.string :description
      t.float :amount_without_taxes
      t.float :tax_amount

      t.timestamps
    end
  end
end
