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
