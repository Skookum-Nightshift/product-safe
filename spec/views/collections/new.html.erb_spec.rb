require 'rails_helper'

RSpec.describe "collections/new", type: :view do
  before(:each) do
    assign(:collection, Collection.new(
      :user_id => 1,
      :item_id => 1
    ))
  end

  it "renders new collection form" do
    render

    assert_select "form[action=?][method=?]", collections_path, "post" do

      assert_select "input#collection_user_id[name=?]", "collection[user_id]"

      assert_select "input#collection_item_id[name=?]", "collection[item_id]"
    end
  end
end
