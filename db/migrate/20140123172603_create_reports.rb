class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.belongs_to :user
      t.belongs_to :reports_pack
      t.string :name
      t.string :summary

      t.timestamps
    end
  end
end
