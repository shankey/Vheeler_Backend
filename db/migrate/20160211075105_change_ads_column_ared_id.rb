class ChangeAdsColumnAredId < ActiveRecord::Migration
  def change
    rename_column :ads, :ared_id, :area_id
  end
end
