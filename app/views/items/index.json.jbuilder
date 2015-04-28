json.array!(@items) do |item|
  json.extract! item, :id, :collection_id, :expiration_date, :image, :barcode, :expiration_date, :amazon_url, :name
  json.url item_url(item, format: :json)
end
