require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before(:each) do
    assign(:item, Item.new(
      :collection_id => 1,
      :expiration_date => "MyString",
      :image => "MyString",
      :barcode => "MyString",
      :expiration_date => "MyString",
      :amazon_url => "MyString",
      :name => "MyString"
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

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
