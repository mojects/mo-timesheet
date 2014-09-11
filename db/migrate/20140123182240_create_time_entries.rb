class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.belongs_to :user
      t.belongs_to :report
      t.string :project
      t.float :hours
      t.string :comment
      t.date :spent_on

      t.timestamps
    end
  end
end
