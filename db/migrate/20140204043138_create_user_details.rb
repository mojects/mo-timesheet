class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.belongs_to :user
      t.belongs_to :report
      t.belongs_to :fee
      t.integer    :time_entry_id
      t.string     :project
      t.float      :hours
      t.string     :comment
      t.date       :spent_on
      t.string     :task
    end
  end
end
