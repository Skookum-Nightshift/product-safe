require 'rails_helper'

RSpec.describe "items/show", type: :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :collection_id => 1,
      :expiration_date => "Expiration Date",
      :image => "Image",
      :barcode => "Barcode",
      :expiration_date => "Expiration Date",
      :amazon_url => "Amazon Url",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Expiration Date/)
    expect(rendered).to match(/Image/)
    expect(rendered).to match(/Barcode/)
    expect(rendered).to match(/Expiration Date/)
    expect(rendered).to match(/Amazon Url/)
    expect(rendered).to match(/Name/)
  end
end
