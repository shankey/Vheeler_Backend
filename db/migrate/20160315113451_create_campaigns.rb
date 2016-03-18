class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :user_id
      t.string :integer
      t.decimal :time ,:precision => 10, :scale => 2

      t.timestamps null: false
    end
  end
end
