class SearchController < ApplicationController
  respond_to :json

  def item_search
    request = Vacuum.new

    request.configure(
      aws_access_key_id: ENV["S3_KEY_ID"],
      aws_secret_access_key: ENV["S3_SECRET"],
      associate_tag: "tag"
    )

    response = request.item_lookup(
      query: {
        'ItemId' => params[:item_id],
        'IdType' => 'ISBN',
        'SearchIndex' => 'All'
      }
    )
    

      
  end
end
