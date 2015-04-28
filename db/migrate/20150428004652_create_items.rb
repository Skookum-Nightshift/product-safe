class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :collection_id
      t.string :expiration_date
      t.string :image
      t.string :barcode
      t.string :expiration_date
      t.string :amazon_url
      t.string :name

      t.timestamps null: false
    end
  end
end
