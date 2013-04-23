class CreateTshirts < ActiveRecord::Migration
  def change
    create_table :tshirts do |t|
      t.string :name
      t.string :size
      t.string :color
      t.string :condition
      t.integer :rating
      t.string :tags
      t.text :note
      t.string :image_url
      t.integer :store_id

      t.timestamps
    end
  end
end
