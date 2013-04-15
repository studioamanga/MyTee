class CreateWashes < ActiveRecord::Migration
  def change
    create_table :washes do |t|
      t.date :date

      t.timestamps
    end
  end
end
