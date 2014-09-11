class FixDefaultsInPayrolls < ActiveRecord::Migration
  def change
    change_column :payrolls, :type, :string, default: 'hourly'
    change_column :payrolls, :currency, :string, default: 'RUB'
  end
end
