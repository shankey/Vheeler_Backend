class CreateAreaInfos < ActiveRecord::Migration
  def change
    create_table :area_infos do |t|
      t.integer :area_id
      t.string :area_info

      t.timestamps null: false
    end
  end
end
