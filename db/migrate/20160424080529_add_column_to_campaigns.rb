class AddColumnToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :start_date, :date
  end
end
