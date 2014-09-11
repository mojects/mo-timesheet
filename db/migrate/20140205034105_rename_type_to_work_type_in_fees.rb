class RenameTypeToWorkTypeInFees < ActiveRecord::Migration
  def change
    rename_column :fees, :type, :work_type
    change_column :fees, :work_type, :string
    change_column_default :fees, :work_type, 'hourly'
    add_index :fees, :work_type
  end
end
