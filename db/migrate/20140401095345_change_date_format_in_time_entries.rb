class ChangeDateFormatInTimeEntries < ActiveRecord::Migration
  def up
    change_column :time_entries, :spent_on, :datetime
  end

  def down
    change_column :time_entries, :spent_on, :date
  end
end
