class AddConfigSectionIdToDataSource < ActiveRecord::Migration
  def change
    add_column :data_sources, :config_section_id, :string, unique: true
  end
end
