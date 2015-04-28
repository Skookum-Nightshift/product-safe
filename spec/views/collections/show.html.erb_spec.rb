require 'rails_helper'

RSpec.describe "collections/show", type: :view do
  before(:each) do
    @collection = assign(:collection, Collection.create!(
      :user_id => 1,
      :item_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
