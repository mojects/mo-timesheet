class RenameTypeToWorkTypeInPayrolls < ActiveRecord::Migration
  def change
    rename_column :payrolls, :type, :work_type
  end
end
