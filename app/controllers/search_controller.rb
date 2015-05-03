class SearchController < ApplicationController
  respond_to :json

  def item_search(item)
    request = Vacuum.new

    request.configure(
      aws_access_key_id: ENV["S3_KEY_ID"],
      aws_secret_access_key: ENV["S3_SECRET"],
      associate_tag: "tag"
    )

    response = request.item_lookup(
      query: {
        'ItemId' => '076243631X',
        'IdType' => 'ISBN',
        'SearchIndex' => 'All'
      }
    )

    item.name = response.to_h["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Name"] ? response.to_h["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Name"] : response.to_h["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"]

      
  end
end
