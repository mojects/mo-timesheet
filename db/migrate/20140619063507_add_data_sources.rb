class AddDataSources < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
      t.string :name, unique: true
      t.string :connector_type
      t.string :primary, default: 'no'
      t.timestamps
    end

    add_index :data_sources, :primary

    remove_column :time_entries, :source
    add_column :time_entries, :data_source_id, :integer

    say 'Creating many-to-many for users and data_sources'
    create_join_table :users, :data_sources do |t|
      t.integer :external_user_id
    end
  end
end
