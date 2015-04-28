require 'rails_helper'

RSpec.describe "collections/index", type: :view do
  before(:each) do
    assign(:collections, [
      Collection.create!(
        :user_id => 1,
        :item_id => 2
      ),
      Collection.create!(
        :user_id => 1,
        :item_id => 2
      )
    ])
  end

  it "renders a list of collections" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
