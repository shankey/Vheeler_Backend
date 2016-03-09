class ChangeVersionColumnName < ActiveRecord::Migration
  def change
    change_column :versions, :name, :string
  end
end
