class CreateInvoicesPacks < ActiveRecord::Migration
  def change
    create_table :invoices_packs do |t|
      t.belongs_to :reports_pack
      t.float :with_taxes
      t.float :taxes
      t.string :base_currency

      t.timestamps
    end
  end
end
