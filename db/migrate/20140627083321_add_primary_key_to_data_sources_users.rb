class AddPrimaryKeyToDataSourcesUsers < ActiveRecord::Migration
  def change
    add_column :data_sources_users, :id, :primary_key
  end
end
