class CreateCampaignAreas < ActiveRecord::Migration
  def change
    create_table :campaign_areas do |t|
      t.integer :campaign_id
      t.integer :area_id
      t.integer :ad_id
      t.decimal :time, :precision => 10, :scale => 2
      t.decimal :distance, :precision => 10, :scale => 2

      t.timestamps null: false
    end
  end
end
