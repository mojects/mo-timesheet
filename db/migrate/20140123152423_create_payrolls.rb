class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.belongs_to :user
      t.float :amount
      t.string :name
      t.date :effective_since
      t.integer :type, default: 1

      t.timestamps
    end
  end
end
