class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.integer :ared_id
      t.string :url

      t.timestamps null: false
    end
  end
end
