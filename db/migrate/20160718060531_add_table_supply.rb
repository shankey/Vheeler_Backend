class AddTableSupply < ActiveRecord::Migration
  def change
  	create_table :supply do |t|
      t.integer :supply_id
      t.decimal :device_id
      t.decimal :campaign_id

      t.timestamps null: false

    end
    add_index :supply, :device_id
  end
end
