class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.belongs_to :report
      t.integer :type, default: 1
      t.string :comment
      t.integer :hours
      t.float :sum

      t.timestamps
    end
  end
end
