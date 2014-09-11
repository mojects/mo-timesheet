class CreateReportsPacks < ActiveRecord::Migration
  def change
    create_table :reports_packs do |t|
      t.date :start_time
      t.date :finish_time

      t.timestamps
    end
  end
end
