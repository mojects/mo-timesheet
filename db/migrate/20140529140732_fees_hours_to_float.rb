class FeesHoursToFloat < ActiveRecord::Migration
  def change
    change_column :fees, :hours, :float
  end
end
