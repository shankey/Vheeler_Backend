class AddDefaultToExhaustedTime < ActiveRecord::Migration
  def change
  	change_column :campaign_runs, :exhausted_time, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end
end
