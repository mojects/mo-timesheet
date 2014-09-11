class ChangeWorkTypeInFees < ActiveRecord::Migration
  def change
    change_column :fees, :work_type, :string, default: 'hourly'
  end
end
