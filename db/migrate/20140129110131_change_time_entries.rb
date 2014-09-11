class ChangeTimeEntries < ActiveRecord::Migration
  def change
    change_table :time_entries do |t|
      t.remove :created_at, :updated_at
      t.datetime :start_time
      t.datetime :finish_time
      t.integer :external_id
      t.string :source
      t.string :task
    end
  end
end
