class AddTableCampaignRun < ActiveRecord::Migration
  def change
  	create_table :campaign_run do |t|
      t.integer :campaign_info_id
      t.date :date
      t.decimal :total_time, :precision => 10, :scale => 2
      t.decimal :exhausted_time, :precision => 10, :scale => 2
    end
  end
end
