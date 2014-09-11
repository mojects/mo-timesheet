class FixPayrolls < ActiveRecord::Migration
  def change
    change_column :payrolls, :type, :string
    add_index :payrolls, :type
    add_column :payrolls, :currency, :string
    add_index :payrolls, :currency
  end
end
