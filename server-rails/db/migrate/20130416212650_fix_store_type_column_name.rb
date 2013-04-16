class FixStoreTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :stores, :type, :storeType
  end
end
