class AddColumnToFees < ActiveRecord::Migration
  def change
    add_column :fees, :payroll_id, :integer
  end
end
