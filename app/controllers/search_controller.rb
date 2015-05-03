class SearchController < ApplicationController
  respond_to :json

  def item_search
    api_request = Vacuum.new

    api_request.configure(
      aws_access_key_id: ENV["AWS_KEY"],
      aws_secret_access_key: ENV["AWS_SECRET"],
      associate_tag: ENV["AWS_ASSOCIATE_TAG"]
    )

    response = request.item_lookup(
      query: {
        'ItemId' => '#{@item.barcode}',
        'IdType' => 'ISBN',
        'SearchIndex' => 'All'
      }
    )

    respond_with results.as_json
  end
end
