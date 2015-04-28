require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :collection_id => 1,
      :expiration_date => "MyString",
      :image => "MyString",
      :barcode => "MyString",
      :expiration_date => "MyString",
      :amazon_url => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(@item), "post" do

      assert_select "input#item_collection_id[name=?]", "item[collection_id]"

      assert_select "input#item_expiration_date[name=?]", "item[expiration_date]"

      assert_select "input#item_image[name=?]", "item[image]"

      assert_select "input#item_barcode[name=?]", "item[barcode]"

      assert_select "input#item_expiration_date[name=?]", "item[expiration_date]"

      assert_select "input#item_amazon_url[name=?]", "item[amazon_url]"

      assert_select "input#item_name[name=?]", "item[name]"
    end
  end
end
