require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    assign(:items, [
      Item.create!(
        :collection_id => 1,
        :expiration_date => "Expiration Date",
        :image => "Image",
        :barcode => "Barcode",
        :expiration_date => "Expiration Date",
        :amazon_url => "Amazon Url",
        :name => "Name"
      ),
      Item.create!(
        :collection_id => 1,
        :expiration_date => "Expiration Date",
        :image => "Image",
        :barcode => "Barcode",
        :expiration_date => "Expiration Date",
        :amazon_url => "Amazon Url",
        :name => "Name"
      )
    ])
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Expiration Date".to_s, :count => 2
    assert_select "tr>td", :text => "Image".to_s, :count => 2
    assert_select "tr>td", :text => "Barcode".to_s, :count => 2
    assert_select "tr>td", :text => "Expiration Date".to_s, :count => 2
    assert_select "tr>td", :text => "Amazon Url".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
