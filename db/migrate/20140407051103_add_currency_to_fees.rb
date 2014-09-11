class AddCurrencyToFees < ActiveRecord::Migration
  def change
    add_column :fees, :currency, :string, limit: 3
  end
end
