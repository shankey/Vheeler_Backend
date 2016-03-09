class ChangeAreasColumnAredId < ActiveRecord::Migration
  def change
    rename_column :areas, :ared_id, :area_id
  end
end
