require 'rails_helper'

RSpec.describe "collections/edit", type: :view do
  before(:each) do
    @collection = assign(:collection, Collection.create!(
      :user_id => 1,
      :item_id => 1
    ))
  end

  it "renders the edit collection form" do
    render

    assert_select "form[action=?][method=?]", collection_path(@collection), "post" do

      assert_select "input#collection_user_id[name=?]", "collection[user_id]"

      assert_select "input#collection_item_id[name=?]", "collection[item_id]"
    end
  end
end
