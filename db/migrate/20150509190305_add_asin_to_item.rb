class AddAsinToItem < ActiveRecord::Migration
  def change
    add_column :items, :ASIN, :string
  end
end
