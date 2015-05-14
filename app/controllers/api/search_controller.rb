class Api::SearchController < ApplicationController
  respond_to :json

  def find_all_where
    page = params[:page] || "1"
    request = Vacuum.new

    request.configure(
      aws_access_key_id: ENV["S3_KEY_ID"],
      aws_secret_access_key: ENV["S3_SECRET"],
      associate_tag: "tag"
    )

    response = request.item_search(
      query: {
        'Keywords' => params[:search_term],
        'SearchIndex' => 'All',
        'ItemPage' => page
      }
    )

    items = []
    response.to_h["ItemSearchResponse"]["Items"]["Item"].each do |item|
      items.push(item_search(item["ASIN"]))
    end

    render json: { items: items, searchTerm: params[:search_term] }
  end

  def find_users_item
    items = Item.find_by_fuzzy_name(params[:search_term], :limit => 10)
    
    found_users_items = []
    users_items_ids = Item.joins(:collection).where('collections.user_id', current_user.id).pluck(:id)

    items.each do |item|
      if !users_items_ids.index(item.id).nil?
        found_users_items.push(item)
      end
    end

    render json: { items: found_users_items, searchTerm: params[:search_term] }
  end

  private

    def item_search(item_id)
      request = Vacuum.new

      request.configure(
        aws_access_key_id: ENV["S3_KEY_ID"],
        aws_secret_access_key: ENV["S3_SECRET"],
        associate_tag: "tag"
      )

      response = request.item_lookup(
        query: {
          'ItemId' => item_id,
          'ResponseGroup' => 'Small, Images'
        }
      )

      response.to_h["ItemLookupResponse"]["Items"]["Item"]
    end
end
