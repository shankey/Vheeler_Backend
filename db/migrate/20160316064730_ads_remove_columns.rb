class AdsRemoveColumns < ActiveRecord::Migration
  def change
    remove_column :ads, :time, :distance
  end
end
